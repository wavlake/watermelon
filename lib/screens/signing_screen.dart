import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/constants.dart';
import '../model/state.dart';

class SigningScreen extends StatelessWidget {
  const SigningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    void handleSignEvent() async {
      if (appState.scannedEvent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan an event first')),
        );
        return;
      }
      bool isSuccess = await appState.signEvent();

      // need to check if context.mounted is true before passing context
      // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
      if (isSuccess && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Signed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Signing Failed')),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: WavlakeColors.purple)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              // TODO - this column widget/sized box is causing an overflow error
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                child: SingleChildScrollView(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        text: appState.prettyEventString),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                appState.navigate(Screen.scanner);
              },
              child: const Row(
                children: [
                  Icon(Icons.qr_code_scanner),
                  Text('Scan Event'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: handleSignEvent,
              child: const Text('Sign & Publish'),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "Active Relays",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
        ),
        ...appState.relays.where((element) => element.isActive).map((relay) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appState.successRelays.contains(relay)
                    ? const Icon(
                        Icons.check,
                        color: WavlakeColors.mint,
                      )
                    : const Icon(
                        Icons.close,
                        color: WavlakeColors.red,
                      ),
                Text(relay.url),
              ],
            ),
          );
        }),
      ],
    );
  }
}
