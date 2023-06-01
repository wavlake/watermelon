import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/state.dart';

class SigningScreen extends StatelessWidget {
  const SigningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        title: const Text('Wavlake'),
        backgroundColor: Colors.green.shade300,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to the scanner"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Text("some text here"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Generate new nsec'),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Read saved nsec'),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
