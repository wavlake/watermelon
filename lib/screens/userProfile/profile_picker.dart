import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import 'profile_row.dart';
import '../../model/state.dart';

class ProfilePicker extends StatelessWidget {
  const ProfilePicker({super.key, required this.closeProfilePicker});

  final void Function() closeProfilePicker;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text("Select Account"),
            ),
            ...appState.userProfiles.isEmpty
                ? [const Text("Please add an account...")]
                : appState.userProfiles.map((profile) {
                    return ProfileRow(
                        profile: profile,
                        closeProfilePicker: closeProfilePicker);
                  }).toList(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: ElevatedButton(
                  onPressed: () {
                    appState.labelController.clear();
                    appState.nsecController.clear();
                    appState.navigate(Screen.addUserProfile);
                  },
                  child: const Text("Add New Account")),
            ),
          ]),
    );
  }
}
