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
      height: 100,
      child: TextFormField(
        controller: widget.appState.relayUrlController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "relay url",
        ),
        validator: (value) {
          bool isValidUrl(String url) {
            return Uri.parse(url).isAbsolute;
          }

          if (value == null || value.isEmpty) {
            return 'Url is required';
          }
          if (!isValidUrl(value)) {
            return 'Please enter a valid url';
          }

          return null;
        },
      ),
    );
  }
}
