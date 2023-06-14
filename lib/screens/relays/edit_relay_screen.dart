import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/top_back_button.dart';
import 'package:watermelon/screens/relays/url_input.dart';

import '../../model/state.dart';

class EditRelayScreen extends StatelessWidget {
  const EditRelayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TopBackButton(
          title: "Edit Relay",
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: UrlInput(appState: appState),
        ),
        ElevatedButton(
            onPressed: appState.editRelay, child: const Text("Save")),
      ],
    );
  }
}
