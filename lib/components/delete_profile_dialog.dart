import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:watermelon/model/profiles.dart';
import '../model/state.dart';

Future<void> deleteProfileDialog(BuildContext context, UserProfile profile) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      var appState = context.watch<AppState>();
      return AlertDialog(
        title: const Text('Delete profile'),
        content: const Text(
          "This will delete the profile from your device. Please ensure you have backed up the private key.",
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Delete Profile'),
            onPressed: () {
              appState.deleteProfile(profile);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
