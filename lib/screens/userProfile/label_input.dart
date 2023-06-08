import 'package:flutter/material.dart';

import '../../model/state.dart';

class LabelInput extends StatefulWidget {
  const LabelInput({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  State<LabelInput> createState() => _LabelInputState();
}

class _LabelInputState extends State<LabelInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TextFormField(
        controller: widget.appState.labelController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "label",
        ),
      ),
    );
  }
}
