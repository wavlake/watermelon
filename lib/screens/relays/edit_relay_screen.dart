import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/top_back_button.dart';
import 'package:watermelon/screens/relays/url_input.dart';

import '../../model/state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Column(
      children: [
        const TopBackButton(
          title: "Edit Account",
        ),
        UrlInput(appState: appState),
        ElevatedButton(
            onPressed: appState.saveRelayUrl, child: const Text("Save")),
      ],
    );
  }
}
