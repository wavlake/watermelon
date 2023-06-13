import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/screens/relays/url_input.dart';

import '../../components/top_back_button.dart';
import '../../model/state.dart';

class AddUserProfileScreen extends StatelessWidget {
  const AddUserProfileScreen({
    super.key,
    required this.closeRelayPicker,
  });

  final void Function() closeRelayPicker;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Form(
        key: appState.formKey,
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
                  UrlInput(appState: appState),
                  ElevatedButton(
                    onPressed: () {
                      if (appState.formKey.currentState!.validate()) {
                        appState.addRelay();
                        closeRelayPicker();
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
                        closeRelayPicker();
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
