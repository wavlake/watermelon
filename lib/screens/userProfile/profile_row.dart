import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/user_avatar.dart';
import 'package:watermelon/model/constants.dart';

import '../../components/delete_profile_dialog.dart';
import '../../model/profiles.dart';
import '../../model/state.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow(
      {super.key, required this.profile, required this.closeProfilePicker});

  final UserProfile profile;
  final void Function() closeProfilePicker;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const UserAvatar(size: 30),
            TextButton(
                onPressed: () {
                  appState.makeProfileActive(profile);
                },
                child: Text(profile.label)),
          ],
        ),
        Row(
          children: [
            profile.isActive
                ? TextButton(
                    child: const Opacity(
                      opacity: 1,
                      child: Icon(
                        Icons.circle,
                        // TODO - add wavlake colors
                        color: Color.fromARGB(255, 241, 119, 160),
                        size: 20.0,
                      ),
                    ),
                    onPressed: () {
                      closeProfilePicker();
                      appState.navigate(Screen.signing);
                    })
                : TextButton(
                    child: const Opacity(
                      opacity: 0.3,
                      child: Icon(
                        Icons.circle,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                    onPressed: () {
                      appState.makeProfileActive(profile);
                      closeProfilePicker();
                    }),
            TextButton(
                onPressed: () =>
                    deleteProfileDialog(context, profile, closeProfilePicker),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20.0,
                )),
          ],
        ),
      ],
    );
  }
}
