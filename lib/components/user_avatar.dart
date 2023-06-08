import 'package:flutter/material.dart';
import 'package:watermelon/model/user_profile.dart';
import '../model/constants.dart';
import '../model/state.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 80, required this.profile});
  final double size;
  final UserProfile profile;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // if (appState.activeProfile != null) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              appState.setEditingProfile(profile);
              appState.navigate(Screen.editUserProfile);
            },
            child: SizedBox(
                width: size,
                height: size,
                child: Image.network(profile.profileUrl))),
      ],
    );
  }
}
