import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/screens/relays/url_input.dart';

import '../../components/top_back_button.dart';
import '../../model/state.dart';

class AddRelayScreen extends StatelessWidget {
  const AddRelayScreen({
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
                      closeRelayPicker();
                      appState.addRelay();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            // this is to force the widget above to be centered
            const SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
