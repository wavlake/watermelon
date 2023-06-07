import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import 'profile_row.dart';
import '../../components/delete_all_data_dialog.dart';
import '../../model/state.dart';
import 'add_profile_form.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var isAddingAccount = false;

  void toggleAddAccount() {
    setState(() {
      isAddingAccount = !isAddingAccount;
    });
  }

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
                      onPressed: toggleAddAccount),
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
