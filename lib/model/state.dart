import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _keyGenerator = KeyApi();
final _nip19 = Nip19();

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
  String relay = "wss://relay.wavlake.com";
  String insecurePrivateHex = "";
  int currentScreen = 0;
  TextEditingController nsecController = TextEditingController();

  // a getter that transforms the privateHex to publicHex
  String get publicHexKey {
    if (insecurePrivateHex == "") return "";
    return _keyGenerator.getPublicKey(insecurePrivateHex);
  }

  // a getter that transforms the privateHex to npub
  String get npubKey {
    if (insecurePrivateHex == "") return "";
    var publicHexKey = _keyGenerator.getPublicKey(insecurePrivateHex);
    return _nip19.npubEncode(publicHexKey);
  }

  // a getter that transforms the privateHex to nsec
  String get nsecKey {
    if (insecurePrivateHex == "") return "";
    return _nip19.nsecEncode(insecurePrivateHex);
  }

  final formKey = GlobalKey<FormState>();

  void navigate(int index) {
    currentScreen = index;

    notifyListeners();
  }

  void generateNewNsec() {
    insecurePrivateHex = _keyGenerator.generatePrivateKey();
    nsecController.text = nsecKey;
    notifyListeners();
  }

  void clearNsecField() {
    insecurePrivateHex = "";
    nsecController.text = "";
    notifyListeners();
  }

  Future<void> savePrivateHex() async {
    insecurePrivateHex = _nip19.decode(nsecController.text)['data'];
    await _writeSecretKey(value: insecurePrivateHex);

    // delete local state copies of secrets
    clearNsecField();
    navigate(2);

    notifyListeners();
  }

  Future<void> deletePrivateHex() async {
    await _deleteSecretKey();
    clearNsecField();
    notifyListeners();
  }

  Future<String?> readPrivateHex() async {
    // read the key but dont store anywhere, since its a secret
    return await _readSecretKey();
  }

  bool isValidNsec(String value) {
    try {
      // nsec should be 63 chars
      if (value.length != 63) {
        return false;
      }
      final nip19 = Nip19();
      var insecurePrivateHex = nip19.decode(value);
      if (insecurePrivateHex['type'] != 'nsec') {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error validating Nsec: $e");
      return false;
    }
  }

  // Private methods

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

class SecItem {
  SecItem(this.key, this.value);

  final String key;
  final String value;
}
