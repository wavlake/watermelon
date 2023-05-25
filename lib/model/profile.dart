import 'package:flutter/material.dart';
import 'package:nostr_tools/nostr_tools.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _keyGenerator = KeyApi();
final _nip19 = Nip19();

const _storage = FlutterSecureStorage();

IOSOptions _getIOSOptions() => IOSOptions(
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

  final List<String> uiMessage = [];
  List<SecItem> items = List<SecItem>.empty(growable: true);

  TextEditingController nsecController = TextEditingController();
  void clearUiMessage() {
    uiMessage.clear();
    notifyListeners();
  }
  void generateNewNsec() {
    var privateHex = _keyGenerator.generatePrivateKey();
    var publicHex =  _keyGenerator.getPublicKey(privateHex);
    var nsecKey = _nip19.nsecEncode(privateHex);
    var npubKey = _nip19.npubEncode(publicHex);

    uiMessage.add("Private Key generated: $nsecKey");
    uiMessage.add("Public key derived from: $npubKey");
    uiMessage.add("private key hex derived from: $privateHex");
    uiMessage.add("Public key hex derived from: $publicHex");
    notifyListeners();
  }
  void submitUserNsec() {
    var privateHex = _nip19.decode(nsecController.text);
    var publicHex = _keyGenerator.getPublicKey(privateHex['data']);
    uiMessage.add("submitting nsec ${privateHex['data']}");
    uiMessage.add("submitting npub $publicHex");

    notifyListeners();
  }

  Future<void> readSecrets() async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    items = all.entries
      .map((entry) => SecItem(entry.key, entry.value))
      .toList(growable: false);
    print(items.length);
    print(items.map((e) => e.key));
    print(items.map((e) => e.value));
  }

  Future<void> addSecret() async {
    int index = items.length;
    String key = "testKey $index";
    String value = "testValue $index";

    print(_getIOSOptions().toMap());
    print(_getAndroidOptions().toMap());
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readSecrets();
  }
}

class SecItem {
  SecItem(this.key, this.value);

  final String key;
  final String value;
}
