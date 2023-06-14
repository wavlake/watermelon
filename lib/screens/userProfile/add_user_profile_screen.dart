import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/top_back_button.dart';
import '../../model/state.dart';
import 'label_input.dart';
import 'nsec_input.dart';

class AddUserProfileScreen extends StatelessWidget {
  const AddUserProfileScreen({
    super.key,
    required this.closeProfilePicker,
  });

  final void Function() closeProfilePicker;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Form(
        key: appState.addProfileForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TopBackButton(
              title: "Add an Account",
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NsecInput(appState: appState),
                  LabelInput(appState: appState),
                  ElevatedButton(
                    onPressed: () {
                      if (appState.addProfileForm.currentState!.validate()) {
                        closeProfilePicker();
                        appState.addNewProfile();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Key')),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextButton(
                      onPressed: () {
                        closeProfilePicker();
                        appState.generateNewNsec();
                      },
                      child: const Text("Generate a new key")),
                ),
              ],
            ),
          ],
        ));
  }
}
