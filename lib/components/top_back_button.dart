import 'package:flutter/material.dart';
import '../model/constants.dart';
import '../model/state.dart';
import 'package:provider/provider.dart';

// Every screen gets a default back button target
Map<Screen, Screen> backButtonMap = {
  Screen.welcome: Screen.welcome,
  Screen.addUserProfile: Screen.signing,
  Screen.signing: Screen.addUserProfile,
  Screen.scanner: Screen.signing,
  Screen.editUserProfile: Screen.signing,
  Screen.addRelay: Screen.signing,
  Screen.editRelay: Screen.signing,
};

class TopBackButton extends StatelessWidget {
  const TopBackButton({super.key, this.title = ""});

  final String title;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    Screen? targetScreen = backButtonMap[appState.currentScreen];

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
                          appState.navigate(targetScreen ?? Screen.signing),
                  child: const Icon(Icons.arrow_back)),
              if (title.isNotEmpty) Text(title),
            ],
          ),
        ],
      ),
    );
  }
}
