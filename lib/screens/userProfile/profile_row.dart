import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/user_avatar.dart';

import '../../components/delete_profile_dialog.dart';
import '../../model/user_profile.dart';
import '../../model/state.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow(
      {super.key, required this.profile, required this.closeProfilePicker});

  final UserProfile profile;
  final void Function() closeProfilePicker;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return InkWell(
      onTap: () => {
        closeProfilePicker(),
        appState.makeProfileActive(profile),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserAvatar(
                size: 30,
                profile: profile,
              ),
              Text(profile.label),
            ],
          ),
          Row(
            children: [
              profile.isActive
                  ? const Opacity(
                      opacity: 1,
                      child: Icon(
                        Icons.circle,
                        // TODO - add wavlake colors
                        color: Color.fromARGB(255, 241, 119, 160),
                        size: 20.0,
                      ),
                    )
                  : const Opacity(
                      opacity: 0.3,
                      child: Icon(
                        Icons.circle,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
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
      ),
    );
  }
}
