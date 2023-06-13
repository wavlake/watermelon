import 'package:flutter/material.dart';

import '../../model/state.dart';

class UrlInput extends StatefulWidget {
  const UrlInput({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  State<UrlInput> createState() => _UrlInputState();
}

class _UrlInputState extends State<UrlInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35,
        width: 200,
        child: TextFormField(
            controller: widget.appState.relayUrlController,
            decoration:
                const InputDecoration(contentPadding: EdgeInsets.all(5))));
  }
}
