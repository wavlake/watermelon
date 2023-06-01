import 'package:flutter/material.dart';
import '../model/state.dart';

class TopBackButton extends StatelessWidget {
  const TopBackButton({
    super.key,
    required this.appState,
    this.title = "",
  });

  final AppState appState;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () => appState.navigate(appState.currentScreen - 1),
              child: const Icon(Icons.arrow_back)),
          if (title.isNotEmpty) Text(title),
        ],
      ),
    );
  }
}
