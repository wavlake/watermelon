import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../components/top_back_button.dart';
import '../model/state.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Column(
      children: [
        const TopBackButton(title: "Scan a nostr event QR code"),
        // Mobile Scanner is finnicky
        // its immediate parent needs to be something like SizedBox
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SizedBox(
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
        ),
      ],
    );
  }
}
