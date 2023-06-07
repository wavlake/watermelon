import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import 'profile_row.dart';
import '../../components/delete_all_data_dialog.dart';
import '../../model/state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.closeProfilePicker});

  final void Function() closeProfilePicker;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Select Account"),
            ...appState.userProfiles.isEmpty
                ? [const Text("Please add an account...")]
                : appState.userProfiles.map((profile) {
                    return ProfileRow(
                        profile: profile,
                        closeProfilePicker: closeProfilePicker);
                  }).toList(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    closeProfilePicker();
                    appState.navigate(Screen.addUserProfile);
                  },
                  child: const Text("Add New Account")),
            ),
          ]),
    );
  }
}
