import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../model/state.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var isAddingAccount = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (isAddingAccount) {
      return AddAccountScreen(appState: appState);
    }

    return Scaffold(
        backgroundColor: Colors.pink.shade100,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      children: appState.userProfiles.map((profile) {
                    var w = ProfileRow(profile: profile);
                    return w;
                  }).toList()),
                  ElevatedButton(
                      child: const Text("Add an account"),
                      onPressed: () {
                        setState(() {
                          isAddingAccount = true;
                        });
                      })
                ]),
          ],
        ));
  }
}

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.profile,
  });

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Row(
      children: [
        Text(profile.npub.substring(0, 8)),
        TextButton(
            onPressed: () {
              appState.deleteAccount(profile);
            },
            child: const Text("Delete")),
        TextButton(
            onPressed: () {
              appState.makeAccountActive(profile);
            },
            child: const Text("Make Active")),
        TextButton(
            onPressed: () {
              appState.editAccount(profile);
            },
            child: const Text("Edit")),
      ],
    );
  }
}

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Form(
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
                        appState.addNewProfile();
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
            Column(
              children: [
                ElevatedButton(
                  onPressed: appState.removeAllUserData,
                  child: const Text('Delete All User Data'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextButton(
                      onPressed: appState.generateNewNsec,
                      child: const Text("Generate New Key")),
                ),
              ],
            ),
          ],
        ));
  }
}
