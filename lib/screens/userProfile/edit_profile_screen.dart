import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/top_back_button.dart';

import '../../model/state.dart';
import 'label_input.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TopBackButton(
          title: "Edit Profile",
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: LabelInput(appState: appState),
        ),
        ElevatedButton(
            onPressed: appState.saveLabel, child: const Text("Save")),
      ],
    );
  }
}
