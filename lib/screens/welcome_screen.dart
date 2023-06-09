import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/constants.dart';
import '../model/state.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          const Image(
              height: 200, image: AssetImage("assets/wavlake-icon-512.png")),
          const Text("Wavlake Signer App"),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: () => appState.navigate(Screen.signing),
              child: const Text("Start"),
            ),
          ),
          const Text("Sign and publish nostr events"),
        ]));
  }
}
