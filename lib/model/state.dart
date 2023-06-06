// import 'package:bip340/bip340.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:nostr/nostr.dart' as nostr;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';

import 'constants.dart';

class PointlessTimer {
  PointlessTimer(Duration d) {
    _timer = Timer(d, () => _completer.complete());
  }

  late final Timer _timer;
  final _completer = Completer();

  Future get future => _completer.future;

  void cancel() {
    _timer.cancel();
    _completer.complete();
  }
}
// final pointless = PointlessTimer(Duration(seconds: 3));
// Timer(Duration(seconds: 2), () => pointless.cancel());
// await pointless.future;

final _keyGenerator = KeyApi();
final _nip19 = Nip19();
final eventApi = EventApi();
const _storage = FlutterSecureStorage();
const storageKeyPrivateHex = "privateHexKey";
const storageKeyUserProfiles = "userPrivateProfiles";

class UserProfile {
  // nsec is marked as required since we dont have a default value like isActive
  // TODO - accept privateHex in addition to nsec
  UserProfile({required this.nsec, isActive}) {
    nsec = nsec;
    isActive = isActive;
  }

  String nsec;
  bool isActive = false;

  // these are all dervied from the nsec
  String get npub {
    _keyGenerator.getPublicKey(privateHex);
    return _nip19.npubEncode(publicHex);
  }

  String get privateHex => _nip19.decode(nsec)['data'];
  String get publicHex => _keyGenerator.getPublicKey(privateHex);

  Map<String, dynamic> toJson() {
    return {
      "nsec": nsec,
      "isActive": isActive,
    };
  }
}

IOSOptions _getIOSOptions() => const IOSOptions(
      accountName: "flutter_secure_storage_service",
    );

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
      // sharedPreferencesName: 'Test2',
      // preferencesKeyPrefix: 'Test'
    );

class AppState with ChangeNotifier {
  // this runs when we call AppState() in main.dart in the ChangeNotifierProvider create method
  AppState() {
    setInitialScreen();
  }

  /// Navigation
  Screen currentScreen = Screen.welcome;
  String loadingText = "";

  /// A method that sets the initial screen
  void setInitialScreen() async {
    // // TODO store this boolean in unsecure storage
    // var hasSeenWelcomeScreen = true;
    // if (!hasSeenWelcomeScreen) {
    //   // bail and show the default welcome screen
    //   return;
    // }

    loadingText = "Checking for any stored private keys...";
    navigate(Screen.loading);
    await loadSavedProfiles();

    if (activeProfile == null) {
      // we need a profile to do anything, so show the profile page
      navigate(Screen.userProfile);
    } else {
      // if there is a saved private key, navigate to the signing screen
      navigate(Screen.signing);
    }
  }

  /// A method to navigate to a new screen
  void navigate(Screen newScreen) {
    // update the state
    currentScreen = newScreen;
    notifyListeners();
  }

  /////// Key Entry

  String insecurePrivateHexKey = "";
  TextEditingController nsecController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  /// a getter that transforms the privateHex to publicHex
  String get publicHexKey {
    if (insecurePrivateHexKey == "") return "";
    return _keyGenerator.getPublicKey(insecurePrivateHexKey);
  }

  /// a setter that transforms the privateHex to npub
  set npub(String? privateHexKey) {
    if (privateHexKey == null) return;
    var publicHex = _keyGenerator.getPublicKey(privateHexKey);
    _npub = _nip19.npubEncode(publicHex);
  }

  String get npub => _npub ?? "";
  String? _npub;

  /// a getter that transforms the privateHex to nsec
  String get nsecKey {
    if (insecurePrivateHexKey == "") return "";
    return _nip19.nsecEncode(insecurePrivateHexKey);
  }

  void generateNewNsec() {
    insecurePrivateHexKey = _keyGenerator.generatePrivateKey();
    nsecController.text = nsecKey;
    notifyListeners();
  }

  void clearNsecField() {
    insecurePrivateHexKey = "";
    nsecController.text = "";
    notifyListeners();
  }

  Future<void> deleteAccount(UserProfile profile) async {
    userProfiles.remove(profile);
    // json encode for storage
    var updatedProfiles =
        jsonEncode(userProfiles.map((e) => e.toJson()).toList());

    await _writeSecretKey(value: updatedProfiles, key: storageKeyUserProfiles);

    notifyListeners();
  }

  Future<void> editAccount(UserProfile profile) async {}
  Future<void> makeAccountActive(UserProfile profile) async {}

  Future<void> removeAllUserData() async {
    await _deleteSecretKey(key: storageKeyPrivateHex);
    await _deleteSecretKey(key: storageKeyUserProfiles);

    notifyListeners();
  }

  Future<void> addNewProfile() async {
    try {
      var newUserProfile = UserProfile(
        nsec: nsecController.text,
        // if there is no active profile, set this first one to active
        isActive: activeProfile == null ? true : false,
      );

      // json encode for storage
      var updatedProfiles =
          jsonEncode(userProfiles.map((e) => e.toJson()).toList());

      await _writeSecretKey(
          value: updatedProfiles, key: storageKeyUserProfiles);
      // after a succesfull write, add to local state as well
      userProfiles.add(newUserProfile);

      clearNsecField();
      navigate(Screen.signing);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding new profile: $e");
    }
  }

  Future<void> deletePrivateHex() async {
    await _deleteSecretKey();
    clearNsecField();
    notifyListeners();
  }

  bool isValidNsec(String value) {
    try {
      // nsec should be 63 chars
      if (value.length != 63) {
        return false;
      }
      final nip19 = Nip19();
      var insecurePrivateHexKey = nip19.decode(value);
      if (insecurePrivateHexKey['type'] != 'nsec') {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error validating Nsec: $e");
      return false;
    }
  }

  /////// Event Scanning

  String relayAddress = "wss://relay.wavlake.com";

  /// the last event that was scanned or entered
  nostr.Event? scannedEvent;

  // a getter that transforms the scannedEvent into a string
  String get prettyEventString {
    if (scannedEvent == null) return "Scan an event...";

    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(scannedEvent);
    return prettyprint;
  }

  void parseEventJson(String? jsonString) {
    if (jsonString == null) return;
    try {
      final Map<String, dynamic> jsonEvent = jsonDecode(jsonString);

      // The nostr lib requires a signature string be present
      if (jsonEvent["sig"] == null) {
        // This is overwritten when the user signs the event
        jsonEvent["sig"] = "Tap sign to sign this event";
      }
      // don't verify the event, since the sig is invalid
      scannedEvent = nostr.Event.fromJson(jsonEvent, verify: false);

      navigate(Screen.signing);
    } catch (e) {
      debugPrint("Error parsing event json: $e");
    }

    notifyListeners();
  }

  Future<nostr.Event> signEvent() async {
    if (scannedEvent == null || activeProfile == null) {
      // sign event page should only be exposed if there is a private key to use
      throw UnimplementedError('Event or private key is null');
    } else {
      // activeProfile is nullable, but we checked for that above
      var signingKey = activeProfile!.privateHex;

      // sign the event
      // any pubkey in the unsigned event is ignored
      var signedEvent = nostr.Event.from(
        createdAt: scannedEvent!.createdAt,
        kind: scannedEvent!.kind,
        tags: scannedEvent!.tags,
        content: scannedEvent!.content,
        privkey: signingKey,
      );
      if (!signedEvent.isValid()) {
        throw UnimplementedError('Error signing event');
      }

      await publishEvent(signedEvent);

      notifyListeners();
      return signedEvent;
    }
  }

  Future<void> publishEvent(nostr.Event event) async {
    // We may want to open this socket earlier
    WebSocket webSocket = await WebSocket.connect(relayAddress);
    webSocket.add(event.serialize());
    // and maybe keep it open longer
    await webSocket.close();
  }

  // The user profile that is currently active, can be null
  UserProfile? get activeProfile {
    try {
      return userProfiles.firstWhere((element) => element.isActive);
    } catch (e) {
      // if no active profile is found, return null
      return null;
    }
  }

  List<UserProfile> userProfiles = [];

  Future<void> loadSavedProfiles() async {
    final jsonUserProfiles = await _readSecretKey(key: storageKeyUserProfiles);

    try {
      List<dynamic> jsonProfiles = jsonDecode(jsonUserProfiles ?? "");
      List<UserProfile> listOfProfiles = jsonProfiles
          .map((e) => UserProfile(nsec: e['nsec'], isActive: e['isActive']))
          .toList();

      userProfiles = listOfProfiles;
    } catch (e) {
      debugPrint("Error getting all saved profiles: $e");
    }
  }

  /////// Private methods

  Future<void> _deleteSecretKey({key = String}) async {
    await _storage.delete(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> _writeSecretKey({value = String, key = String}) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> _readSecretKey({key = String}) async {
    final privateKey = await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );

    // return the saved private key, or null if not found
    return privateKey;
  }
}
