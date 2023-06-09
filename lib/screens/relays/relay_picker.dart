import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import '../../model/relay.dart';
import '../../model/state.dart';
import 'relay_row.dart';

class RelayPicker extends StatelessWidget {
  const RelayPicker(
      {super.key, required this.closeRelayPicker, required this.uiRelays});

  final void Function() closeRelayPicker;
  final List<Relay> uiRelays;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, left: 15.0, right: 15.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: Text("Relays"),
            ),
            ...appState.relays.isEmpty
                ? [const Text("Please add a relay...")]
                : appState.relays.map((relay) {
                    return RelayRow(
                      relay: relay,
                      closeRelayPicker: closeRelayPicker,
                    );
                  }).toList(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        closeRelayPicker();
                        appState.relayUrlController.text = "wss://";
                        appState.navigate(Screen.addRelay);
                      },
                      child: const Text("Add a relay")),
                  ElevatedButton(
                      onPressed: closeRelayPicker, child: const Text("Close")),
                ],
              ),
            ),
          ]),
    );
  }
}
