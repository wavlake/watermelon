import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/top_back_button.dart';
import 'package:watermelon/components/user_avatar.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TopBackButton(
          title: "Edit Account",
        ),
        Column(
          children: [
            UserAvatar(profile: appState.editingProfile!),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child:
                  Text("${appState.editingProfile!.npub.substring(0, 18)}..."),
            ),
            LabelInput(appState: appState),
            ElevatedButton(
                onPressed: appState.saveLabel, child: const Text("Save")),
          ],
        ),
        // this is a hack to move the above Column sibling to the center
        const SizedBox.shrink()
      ],
    );
  }
}
