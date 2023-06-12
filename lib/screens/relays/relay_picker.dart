import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import '../../model/state.dart';

class RelayPicker extends StatelessWidget {
  const RelayPicker({super.key, required this.closeRelayPicker});

  final void Function() closeRelayPicker;
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
            // ...appState.userProfiles.isEmpty
            //     ? [const Text("Please add an account...")]
            //     : appState.userProfiles.map((profile) {
            //         return ProfileRow(
            //             profile: profile,
            //             closeProfilePicker: closeProfilePicker);
            //       }).toList(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: ElevatedButton(
                  onPressed: () {
                    print("add a relay");
                  },
                  child: const Text("Add a relay")),
            ),
          ]),
    );
    ;
  }
}
