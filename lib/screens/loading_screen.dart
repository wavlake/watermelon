import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/state.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(appState.loadingText)],
        ),
      ],
    );
  }
}
