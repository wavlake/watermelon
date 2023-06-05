import 'package:flutter/material.dart';
import '../model/state.dart';
import 'package:provider/provider.dart';

import 'model/constants.dart';

// Every screen gets a default back button target
Map<Screen, Screen> backButtonMap = {
  Screen.welcome: Screen.welcome,
  Screen.keyEntry: Screen.welcome,
  Screen.signing: Screen.keyEntry,
  Screen.scanner: Screen.signing,
};

class TopBackButton extends StatelessWidget {
  const TopBackButton({
    super.key,
    this.title = "",
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TextButton(
                  onPressed:
                      () => // lookup the back button's target screen using the current screen
                          appState
                              .navigate(backButtonMap[appState.currentScreen]!),
                  child: const Icon(Icons.arrow_back)),
              if (title.isNotEmpty) Text(title),
            ],
          ),
        ],
      ),
    );
  }
}

// a Text widget that returns an npub or nothing if null
class LoggedInAs extends StatelessWidget {
  const LoggedInAs({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    if (appState.npub != "" && appState.npub.isNotEmpty) {
      return Text("Logged in as: ${appState.npub.substring(0, 9)}");
    }

    // if no npub, return "nothing"
    // https://stackoverflow.com/questions/53455358/how-to-present-an-empty-view-in-flutter
    return const SizedBox.shrink();
  }
}
