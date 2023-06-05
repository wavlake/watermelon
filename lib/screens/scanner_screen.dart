import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../model/state.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
      ),
      body: Column(
        children: [
          const TopBackButton(title: "Scan a nostr event QR code"),
          // Mobile Scanner is finnicky
          // its immediate parent needs to be something like SizedBox
          SizedBox(
            height: 400,
            child: MobileScanner(
              // fit: BoxFit.contain,
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.normal,
                facing: CameraFacing.back,
                torchEnabled: false,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  appState.parseEventJson(barcode.rawValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// {
//   "id": "7d2b298bb3cf844f7d1142fc122aeafdbfadf6e42475b73cf38d62e676240005",
//   "pubkey": "5f836955b840df25c5e971e02fd0905bc227c04bd29ea4dbd6a0b82efb346261",
//   "created_at": 1685718780,
//   "kind": 1,
//   "tags": [],
//   "content": "testing flutter",
// }
//   "sig": "35fed0f762884d6091cdf8f5e2e71311a0cbafd3d91ad9daab57cbe69128caab372b2d56ca91885291794bc77792f16814ec596d71adbdf070dfd5a079038828"