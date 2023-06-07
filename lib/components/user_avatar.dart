import 'package:flutter/material.dart';
import '../model/constants.dart';
import '../model/state.dart';
import 'package:provider/provider.dart';

// fake profile image url, update to pull from relay
// https://github.com/nostr-protocol/nips/blob/master/01.md#basic-event-kinds
var profileImageUrl = "https://i.pravatar.cc/200";

// a Text widget that returns an npub or nothing if null
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 80});
  final double size;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // if (appState.activeProfile != null) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              appState.navigate(Screen.addUserProfile);
            },
            child: SizedBox(
                width: size,
                height: size,
                child: Image.network(profileImageUrl))),
      ],
    );
  }
}
