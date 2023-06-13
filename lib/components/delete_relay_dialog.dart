import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model/relay.dart';
import '../model/state.dart';

Future<void> deleteRelayDialog(
    BuildContext context, Relay relay, void Function() closeProfilePicker) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      var appState = context.watch<AppState>();
      return AlertDialog(
        title: const Text('Delete Relay'),
        content: const Text(
          "This will delete the relay from your device.",
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
            child: const Text('Delete Relay'),
            onPressed: () {
              closeProfilePicker();
              appState.deleteRelay(relay);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
