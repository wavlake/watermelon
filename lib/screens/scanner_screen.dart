import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/profile.dart';

class ScannerScreen extends StatelessWidget {
 const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<Profile>();

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        title: const Text('Wavlake'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Text(appState.privateHexKey),
    );
  }
}
