import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../model/constants.dart';
import '../model/state.dart';

class SigningScreen extends StatelessWidget {
  const SigningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      body: Form(
          key: appState.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const UserProfile(),
              SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(appState.prettyEventString),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            appState.navigate(Screen.scanner);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.qr_code_scanner),
                              Text('Scan Event'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            appState.signEvent();
                          },
                          child: const Text('Sign & Publish'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
