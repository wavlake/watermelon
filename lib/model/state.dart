import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:nostr/nostr.dart' as nostr;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watermelon/model/relay.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'user_profile.dart';
import 'constants.dart';

final _keyGenerator = KeyApi();
final _nip19 = Nip19();
final eventApi = EventApi();
const _storage = FlutterSecureStorage();

String nsecToNpub(String nsec) {
  var privateHex = _nip19.decode(nsec)['data'];
  var publicHex = _keyGenerator.getPublicKey(privateHex);
  return _nip19.npubEncode(publicHex);
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
    GetStorage.init();
    initAppState();
  }

  final notSecureStorage = GetStorage();
  List<UserProfile> userProfiles = [];
  Screen currentScreen = Screen.welcome;
  String loadingText = "";
  String unsecurePrivateHexKey = "";
  TextEditingController nsecController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController relayUrlController = TextEditingController();
  final addProfileForm = GlobalKey<FormState>();
  final editProfileForm = GlobalKey<FormState>();
  final addRelayForm = GlobalKey<FormState>();
  final editRelayForm = GlobalKey<FormState>();
  bool showProfileSelector = false;
  UserProfile? editingProfile;
  Relay? editingRelay;
  List<Relay> relays = [];

  void setEditingProfile(UserProfile profile) {
    editingProfile = profile;
    labelController.text = profile.label;
  }

  void setEditingRelay(Relay relay) {
    editingRelay = relay;
    relayUrlController.text = relay.url;
  }

  void saveLabel() {
    editProfile(editingProfile!, labelController.text);
    navigate(Screen.signing);
  }

  /// The user profile that is currently active, can be null
  UserProfile? get activeProfile {
    try {
      var activeProfile =
          userProfiles.firstWhere((element) => element.isActive);
      return activeProfile;
    } catch (e) {
      // if no active profile is found, return null
      return null;
    }
  }

  /// The last event that was scanned or entered
  nostr.Event? scannedEvent;

  /// A getter that transforms the scannedEvent into a string
  String get prettyEventString {
    if (scannedEvent == null) return "Scan an event...";

    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(scannedEvent);
    return prettyprint;
  }

  /// A method that reads from local storage and initializes state
  void initAppState() async {
    var seenWelcomeScreen = notSecureStorage.read(hasSeenWelcomeScreen);
    // check if the user has seen the welcome screen
    if (seenWelcomeScreen == null || seenWelcomeScreen == "false") {
      // show the welcome screen and set the flag to true
      notSecureStorage.write(hasSeenWelcomeScreen, true);
      return;
    }

    loadingText = "Checking for any stored keys...";
    navigate(Screen.loading);
    await loadSavedProfiles();
    await loadSavedRelays();

    if (activeProfile == null) {
      // we need a profile to do anything, so show the profile page
      navigate(Screen.addUserProfile);
    } else {
      // if there is a saved private key, navigate to the signing screen
      navigate(Screen.signing);
    }
  }

  /// A method to navigate to a new screen
  void navigate(Screen newScreen) {
    if (newScreen == Screen.editUserProfile && editingProfile == null) {
      debugPrint(
          "Error: no profile to edit, did you forget to call setEditingProfile");
      return;
    }
    // update the state
    currentScreen = newScreen;
    notifyListeners();
  }

  /////// Key Entry

  void generateNewNsec() {
    unsecurePrivateHexKey = _keyGenerator.generatePrivateKey();
    var nsec = _nip19.nsecEncode(unsecurePrivateHexKey);
    nsecController.text = nsec;

    // add the profile
    addNewProfile();
  }

  void clearNsecField() {
    unsecurePrivateHexKey = "";
    nsecController.text = "";
    notifyListeners();
  }

  Future<void> deleteProfile(UserProfile profile) async {
    userProfiles.remove(profile);

    // if we're deleting the active profile
    if (profile.isActive && userProfiles.isNotEmpty) {
      // promote the first profile to active
      userProfiles.first.setActive(true);
    }
    await updateLocalStorageProfiles();

    var npubMap = await _readSecretKeyMap();
    npubMap.remove(profile.npub);

    // update profile secrets in storage
    await _writeSecretKey(key: secureNpubNsecMap, value: jsonEncode(npubMap));
    notifyListeners();
  }

  Future<void> updateLocalStorageProfiles() async {
    // json encode for storage
    var updatedProfiles =
        jsonEncode(userProfiles.map((e) => e.toJson()).toList());

    // update profiles in storage
    notSecureStorage.write(publicProfileInfo, updatedProfiles);
  }

  Future<void> setActiveRelay(Relay relay, bool isActive) async {
    relay.setActive(isActive);

    await updateRelays();
    notifyListeners();
  }

  Future<void> editRelay() async {
    try {
      editingRelay!.setUrl(relayUrlController.text);

      await updateRelays();
      navigate(Screen.signing);

      notifyListeners();
    } catch (e) {
      debugPrint("Error editing relay: $e");
    }
  }

  Future<void> updateRelays() async {
    // json encode for storage
    var updatedRelays = jsonEncode(relays.map((e) => e.toJson()).toList());

    // update profiles in storage
    notSecureStorage.write(publicRelayList, updatedRelays);
  }

  Future<void> deleteRelay(Relay relay) async {
    relays.remove(relay);

    await updateRelays();
    notifyListeners();
  }

  Future<void> addRelay() async {
    String url = relayUrlController.text;
    var newRelay = Relay(
      url: url,
      isActive: true,
    );
    relays.add(newRelay);
    await updateRelays();
    relayUrlController.text = "";
    navigate(Screen.signing);

    notifyListeners();
  }

  Future<bool> testRelayConnection(String url) async {
    try {
      WebSocket webSocket = await WebSocket.connect(url);
      await webSocket.close();
      return true;
    } catch (e) {
      debugPrint("Error testing relay connection: $e");
      return false;
    }
  }

  Future<void> makeProfileActive(UserProfile targetProfile) async {
    try {
      // set all profiles to inactive
      for (var profile in userProfiles) {
        // update all profiles to inactive
        // except the targetProfile
        profile.setActive(targetProfile.npub == profile.npub);
      }

      await updateLocalStorageProfiles();
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding new profile: $e");
    }
  }

  Future<void> removeAllUserData() async {
    await _deleteSecretKey(key: secureNpubNsecMap);
    userProfiles = [];
    relays = [];

    notifyListeners();
  }

  Future<void> editProfile(UserProfile profile, String label) async {
    try {
      // update the label
      profile.setLabel(label);

      await updateLocalStorageProfiles();
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding new profile: $e");
    }
  }

  Future<void> addNewProfile() async {
    try {
      var label = labelController.text.isEmpty
          ? "New Profile ${userProfiles.length + 1}"
          : labelController.text;
      var newNsec = nsecController.text;
      var newNpub = nsecToNpub(newNsec);
      var newUserProfile = UserProfile(
        npub: newNpub,
        label: label,
      );
      // if there is not activeProfile
      if (activeProfile == null) {
        // make the new profile active
        newUserProfile.setActive(true);
      }

      bool npubAlreadyExists = userProfiles.any((element) {
        return element.npub == newNpub;
      });

      if (npubAlreadyExists) {
        throw UnimplementedError('This profile already exists');
      }

      // add the new profile to the local state list
      userProfiles.add(newUserProfile);

      await updateLocalStorageProfiles();
      var npubMap = await _readSecretKeyMap();
      // add the new secret to the secure storage map
      npubMap.addAll({newNpub: newNsec});

      // update profile secrets in storage
      await _writeSecretKey(key: secureNpubNsecMap, value: jsonEncode(npubMap));

      // clear out the secret key field and navigate to the signing screen
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
      var unsecurePrivateHexKey = nip19.decode(value);
      if (unsecurePrivateHexKey['type'] != 'nsec') {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error validating Nsec: $e");
      return false;
    }
  }

  /////// Event Scanning

  void parseEventJson(String? jsonString) {
    if (jsonString == null) return;
    try {
      final Map<String, dynamic> jsonEvent = jsonDecode(jsonString);

      // The nostr lib requires a signature string be present
      if (jsonEvent["sig"] == null) {
        // This is overwritten when the user signs the event
        // can we skip this????
        jsonEvent["sig"] = "Tap sign to sign this event and add your signature";
      }
      // don't verify the event, since the sig is invalid
      scannedEvent = nostr.Event.fromJson(jsonEvent, verify: false);

      navigate(Screen.signing);
    } catch (e) {
      debugPrint("Error parsing event json: $e");
    }

    notifyListeners();
  }

  /// Signs the scannedEvent that is currently in appState
  /// Returns true if the event was signed and published
  /// Returns false if there was an error or no event available to sign
  Future<bool> signEvent() async {
    if (scannedEvent == null || activeProfile == null) {
      // sign event page should only be exposed if there is a private key to use
      debugPrint('Event or private key is null');
      // bail and dont do anything
      return false;
    } else {
      // activeProfile is nullable, but we checked for that above
      var privateKeyMap = await _readSecretKeyMap();
      var nsecKey = privateKeyMap[activeProfile!.npub];
      var hexSigningKey = _nip19.decode(nsecKey!)['data'];

      if (hexSigningKey == null) {
        debugPrint('Error getting private key');
        return false;
      }

      // sign the event
      // any pubkey in the unsigned event is ignored
      var signedEvent = nostr.Event.from(
        // createdAt: scannedEvent!.createdAt,
        kind: scannedEvent!.kind,
        tags: scannedEvent!.tags,
        content: scannedEvent!.content,
        privkey: hexSigningKey,
      );
      if (!signedEvent.isValid()) {
        debugPrint('Error signing event');
        return false;
      }

      await publishEvent(signedEvent);

      notifyListeners();
      return true;
    }
  }

  List<Relay> successRelays = [];

  Future<void> publishEvent(nostr.Event event) async {
    successRelays = [];

    List<Relay> activeRelays =
        relays.where((element) => element.isActive).toList();

    for (Relay relay in activeRelays) {
      print(relay.url);
      try {
        // We may want to open this socket earlier
        WebSocket webSocket = await WebSocket.connect(relay.url);
        webSocket.add(event.serialize());
        // and maybe keep it open longer
        await webSocket.close();
        successRelays.add(relay);
      } catch (e) {
        debugPrint("Error publishing event: $e");
        debugPrint(relay.url);
      }
    }
    print(successRelays);
  }

  Future<void> loadSavedProfiles() async {
    // update profiles in storage
    var jsonProfiles = notSecureStorage.read(publicProfileInfo);

    try {
      List<dynamic> userProfiles = jsonDecode(jsonProfiles ?? "");
      List<UserProfile> listOfProfiles =
          userProfiles.map((e) => UserProfile.fromJson(e)).toList();

      userProfiles = listOfProfiles;
    } catch (e) {
      debugPrint("Error getting all saved profiles: $e");
    }
  }

  Future<void> loadSavedRelays() async {
    // update profiles in storage
    var jsonRelays = notSecureStorage.read(publicRelayList);

    try {
      relays = jsonDecode(jsonRelays ??
              //  if no stored relays, start with the wavlake relay
              [
                {"url": wavlakeRelay, "isActive": true}
              ])
          .map((e) => Relay.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("Error getting save relays: $e");
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

  Future<void> _writeSecretKey({key = String, value = String}) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<Map<String, dynamic>> _readSecretKeyMap() async {
    final value = await _storage.read(
      key: secureNpubNsecMap,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    if (value == null) {
      return {};
    }
    Map<String, dynamic> map = jsonDecode(value);
    // return the value, or an empty string if not found
    return map;
  }
}
