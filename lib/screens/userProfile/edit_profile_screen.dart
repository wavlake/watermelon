import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/top_back_button.dart';
import 'package:watermelon/model/user_profile.dart';

import '../../model/state.dart';
import 'label_input.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    UserProfile profile = appState.editingProfile!;

    print(profile.label);
    // profile list view
    return Column(
      children: [
        const TopBackButton(
          title: "Edit Account",
        ),
        LabelInput(appState: appState),
        ElevatedButton(
            onPressed: appState.saveLabel, child: const Text("Save")),
      ],
    );
  }
}
