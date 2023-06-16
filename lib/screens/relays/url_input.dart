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
        autocorrect: false,
        keyboardType: TextInputType.url,
        autofocus: true,
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

          // get a list of existing relays, excluding the one being edited
          var otherRelays = [
            ...widget.appState.relays.where((element) {
              return element != widget.appState.editingRelay;
            })
          ];
          // check if any other relay has the same url
          var duplicateUrl = otherRelays.any((element) {
            return element.url == value;
          });

          if (duplicateUrl) {
            return 'This url is already in use';
          }

          return null;
        },
      ),
    );
  }
}
