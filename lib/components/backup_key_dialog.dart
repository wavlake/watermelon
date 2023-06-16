import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:watermelon/model/user_profile.dart';
import '../model/state.dart';

Future<void> backupKeyDialog(BuildContext context, UserProfile profile) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      var appState = context.watch<AppState>();
      return AlertDialog(
        title: const Text('Backup Key'),
        content: RichText(
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text:
                      "Your account is secure by a secret key. The key is a long random string starting with "),
              TextSpan(
                  text: 'nsec1', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text:
                    '. Anyone who has access to your secret key can publish content using your identity.',
              ),
            ],
          ),
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
            child: const Text('Copy key'),
            onPressed: () async {
              Clipboard.setData(
                  ClipboardData(text: await appState.getEditingProfileNsec()));
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
