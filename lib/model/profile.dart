import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _keyGenerator = KeyApi();
final _nip19 = Nip19();

const _storage = FlutterSecureStorage();
const storageKeyPrivateHex = "key|privateHexKey";

IOSOptions _getIOSOptions() => const IOSOptions(
    accountName: "flutter_secure_storage_service",
  );

AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    // sharedPreferencesName: 'Test2',
    // preferencesKeyPrefix: 'Test'
  );

class Profile with ChangeNotifier {
  String relay = "wss://relay.wavlake.com";
  String privateHexKey = "";
  String publicHexKey = "";
  final formKey = GlobalKey<FormState>();

  List<SecItem> secrets = [];
  List<String> nsecs = [];
  List<SecItem> items = List<SecItem>.empty(growable: true);

  TextEditingController nsecController = TextEditingController();

  void generateNewNsec() {
    privateHexKey = _keyGenerator.generatePrivateKey();
    publicHexKey =  _keyGenerator.getPublicKey(privateHexKey);
    var nsecKey = _nip19.nsecEncode(privateHexKey);
    // var npubKey = _nip19.npubEncode(publicHex);

    nsecController.text = nsecKey;

    notifyListeners();
  }
  Future<void> savePrivateHex() async {
    if (storageKeyPrivateHex.isEmpty) return;

    var existingKeys = await readSecrets(filter: storageKeyPrivateHex);
    var keyAlreadyStored = false; // check to see if the key is already stored
    if (keyAlreadyStored) return;
    var key = "$storageKeyPrivateHex|${existingKeys.length + 1}";

    await writeSecret(
      key: key,
      value: privateHexKey,
    );

    notifyListeners();
  }

  Future<void> getStoredNsecs() async {
    var storedHexKeys = secrets.where((element) => element.key.contains(storageKeyPrivateHex));
    nsecs = storedHexKeys
      .map((key) => _nip19.nsecEncode(key.value))
      .toList(growable: false);

    notifyListeners();
  }

  Future<void> writeSecret({ key = String, value = String}) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    // update the app state secrets
    secrets = await readSecrets();
  }

  Future<List<SecItem>> readSecrets({ String filter = "" }) async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    items = all.entries
      .map((entry) => SecItem(entry.key, entry.value))
      .toList(growable: false);

    if (filter == "") {
      return items;
    }
  
    return items
      .where((element) => element.key.contains(filter))
      .toList(growable: false);
  }
}

class SecItem {
  SecItem(this.key, this.value);

  final String key;
  final String value;
}
