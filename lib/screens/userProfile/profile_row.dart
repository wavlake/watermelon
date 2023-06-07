import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/delete_profile_dialog.dart';
import '../../model/profiles.dart';
import '../../model/state.dart';

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
