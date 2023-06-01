import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Welcome to wavlake"),
          ),
          ElevatedButton(
            onPressed: () => appState.navigate(1),
            child: const Text("Add an account"),
          ),
        ]));
  }
}
