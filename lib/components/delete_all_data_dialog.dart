import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model/state.dart';

Future<void> deleteAllDataDialog(
    BuildContext context, void Function() closeProfilePicker) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      var appState = context.watch<AppState>();
      return AlertDialog(
        title: const Text('Delete all data'),
        content: const Text(
          "This will delete all user data, including all profiles and private keys. Please ensure you have backed up your private keys.",
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
            child: const Text('Delete All Data'),
            onPressed: () {
              closeProfilePicker();
              appState.removeAllUserData();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
