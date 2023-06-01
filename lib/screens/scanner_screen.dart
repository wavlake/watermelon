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
          TopBackButton(
              appState: appState,
              title:
                  "Scan a nostr event QR code, like the ones in Wavlake Studio"),
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
                  debugPrint('Barcode found! ${barcode.rawValue}');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
