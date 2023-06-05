import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../model/state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      body: Form(
          key: appState.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopBackButton(
                title: "Add an Account",
              ),
              SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        "If you already have a nostr key, please enter it below, otherwise, please click on the button below to generate a new key"),
                    TextFormField(
                      controller: appState.nsecController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "nsec / hex private key",
                        suffixIcon: IconButton(
                          onPressed: appState.clearNsecField,
                          icon: const Icon(Icons.remove_red_eye_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Key is required';
                        }
                        if (!appState.isValidNsec(value)) {
                          return 'Please enter a valid key';
                        }

                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (appState.formKey.currentState!.validate()) {
                          appState.savePrivateHex();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid Key')),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextButton(
                    onPressed: appState.generateNewNsec,
                    child: const Text("Generate New Key")),
              ),
            ],
          )),
    );
  }
}
