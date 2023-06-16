import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/user_avatar.dart';
import 'package:watermelon/model/constants.dart';

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        // this makes the entire child row clickable
        // default is set to deferToChild, which means only children widget taps are registered
        behavior: HitTestBehavior.opaque,
        onTap: () => {
          closeProfilePicker(),
          appState.makeProfileActive(profile),
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                profile.isActive
                    ? const Opacity(
                        opacity: 1,
                        child: Icon(
                          Icons.circle,
                          color: WavlakeColors.mint,
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
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: UserAvatar(
                    size: 30,
                    profile: profile,
                  ),
                ),
                Text(profile.npubMetadata?.name ?? profile.label),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      closeProfilePicker();
                      appState.setEditingProfile(profile);
                      appState.navigate(Screen.editUserProfile);
                    },
                    child: const Icon(
                      Icons.edit,
                      color: WavlakeColors.mint,
                      size: 20.0,
                    )),
                TextButton(
                    onPressed: () {
                      deleteProfileDialog(context, profile, closeProfilePicker);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: WavlakeColors.orange,
                      size: 20.0,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
