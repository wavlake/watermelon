import 'package:flutter/material.dart';

import '../../model/state.dart';

class NsecInput extends StatefulWidget {
  const NsecInput({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  State<NsecInput> createState() => _NsecInputState();
}

class _NsecInputState extends State<NsecInput> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TextFormField(
        controller: widget.appState.nsecController,
        obscureText: isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "nsec",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscured = !isObscured;
              });
            },
            icon: isObscured
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Key is required';
          }
          if (!widget.appState.isValidNsec(value)) {
            return 'Please enter a valid key';
          }

          return null;
        },
      ),
    );
  }
}
