// import 'package:bip340/bip340.dart';
import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:nostr/nostr.dart' as nostr;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';

import 'constants.dart';

final _keyGenerator = KeyApi();
final _nip19 = Nip19();
final eventApi = EventApi();
const _storage = FlutterSecureStorage();
const storageKeyPrivateHex = "privateHexKey";

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

  /// A method that sets the initial screen
  void setInitialScreen() async {
    // this will save the npub to state if the pk exists
    await checkForSavedPrivateKey();

    // if there is a saved private key, navigate to the signing screen
    if (npub != "") navigate(Screen.signing);

    var hasSeenWelcomeScreen = true; // store this boolean in unsecure storage

    navigate(hasSeenWelcomeScreen ? Screen.userProfile : Screen.welcome);
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

  Future<void> savePrivateHex() async {
    var privateHex = _nip19.decode(nsecController.text)['data'];
    await _writeSecretKey(value: privateHex);

    // save the npub key so we can show the user is logged in
    npub = privateHex;
    clearNsecField();
    navigate(Screen.signing);

    notifyListeners();
  }

  Future<void> deletePrivateHex() async {
    await _deleteSecretKey();
    clearNsecField();
    notifyListeners();
  }

  Future<void> checkForSavedPrivateKey() async {
    // read the key
    var pk = await _readSecretKey();
    // dont save to state, since its a secret
    // instead, derive the npub from it
    npub = pk;
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
    var pk = await _readSecretKey();
    if (scannedEvent == null || pk == null) {
      // sign event page should only be exposed if there is a private key to use
      throw UnimplementedError('Event or private key is null');
    } else {
      // sign the event
      // any pubkey in the unsigned event is ignored
      var signedEvent = nostr.Event.from(
        createdAt: scannedEvent!.createdAt,
        kind: scannedEvent!.kind,
        tags: scannedEvent!.tags,
        content: scannedEvent!.content,
        privkey: pk,
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

  /////// Private methods

  Future<void> _deleteSecretKey() async {
    await _storage.delete(
      key: storageKeyPrivateHex,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> _writeSecretKey({value = String}) async {
    await _storage.write(
      key: storageKeyPrivateHex,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> _readSecretKey() async {
    final privateKey = await _storage.read(
      key: storageKeyPrivateHex,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );

    // return the saved private key, or null if not found
    return privateKey;
  }
}
