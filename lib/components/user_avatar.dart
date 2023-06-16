import 'package:flutter/material.dart';
import 'package:watermelon/model/user_profile.dart';
import '../model/state.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 80, required this.profile});
  final double size;
  final UserProfile profile;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircleAvatar(
              backgroundImage: AssetImage(profile.defaultProfileUrl),
              foregroundImage: profile.npubMetadata?.picture == null
                  ? null
                  : NetworkImage(profile.npubMetadata!.picture)),
        ),
      ],
    );
  }
}
