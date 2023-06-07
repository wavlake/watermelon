import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import '../components.dart';
import '../components/delete_all_data_dialog.dart';
import '../components/delete_profile_dialog.dart';
import '../model/profiles.dart';
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

    // add account form
    if (isAddingAccount) {
      return AddAccountForm(appState: appState);
    }

    // profile list view
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
                      children: appState.userProfiles.isEmpty
                          ? [const Text("Add an account to get started...")]
                          : appState.userProfiles.map((profile) {
                              return ProfileRow(profile: profile);
                            }).toList()),
                  ElevatedButton(
                      child: const Text("Add an account"),
                      onPressed: () {
                        setState(() {
                          isAddingAccount = true;
                        });
                      }),
                  if (appState.activeProfile != null)
                    ElevatedButton(
                        child: const Text("Event Page"),
                        onPressed: () {
                          appState.navigate(Screen.signing);
                        }),
                  ElevatedButton(
                    onPressed: () => deleteAllDataDialog(context),
                    child: const Text('Delete All User Data'),
                  ),
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
        profile.isActive
            ? const Icon(
                Icons.check,
                color: Colors.green,
                size: 20.0,
              )
            : TextButton(
                onPressed: () => deleteProfileDialog(context, profile),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20.0,
                )),
        Text(profile.label),
        TextButton(
            onPressed: () {
              appState.makeProfileActive(profile);
            },
            child: const Text("Make Active")),
        TextButton(
            onPressed: () {
              appState.editProfile(profile, profile.label);
            },
            child: const Text("Update label")),
      ],
    );
  }
}

class AddAccountForm extends StatelessWidget {
  const AddAccountForm({
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
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NsecInput(appState: appState),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextButton(
                      onPressed: appState.generateNewNsec,
                      child: const Text("Generate a new key")),
                ),
              ],
            ),
          ],
        ));
  }
}

class NsecInput extends StatefulWidget {
  const NsecInput({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  State<NsecInput> createState() => _NsecInputState();
}

class _NsecInputState extends State<NsecInput> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TextFormField(
        controller: widget.appState.nsecController,
        obscureText: isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "nsec",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscured = !isObscured;
              });
            },
            icon: isObscured
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Key is required';
          }
          if (!widget.appState.isValidNsec(value)) {
            return 'Please enter a valid key';
          }

          return null;
        },
      ),
    );
  }
}
