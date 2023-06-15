import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/user_avatar.dart';
import '../model/constants.dart';
import '../model/state.dart';

class SigningScreen extends StatelessWidget {
  const SigningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        TopProfileBar(appState: appState),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            EventPreview(appState: appState),
            ScanButton(appState: appState),
            if (appState.scannedEvent != null) SignButton(appState: appState),
          ],
        ),
        const SizedBox(
          height: 10,
        )
        // ...appState.relays.where((element) => element.isActive).map((relay) {
        //   return Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         appState.successRelays.contains(relay)
        //             ? const Icon(
        //                 Icons.check,
        //                 color: WavlakeColors.mint,
        //               )
        //             : const Icon(
        //                 Icons.close,
        //                 color: WavlakeColors.red,
        //               ),
        //         Text(relay.url),
        //       ],
        //     ),
        //   );
        // }),
      ],
    );
  }
}

class TopProfileBar extends StatelessWidget {
  const TopProfileBar({
    super.key,
    required this.appState,
  });
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    if (appState.activeProfile == null) {
      return const Text("No Profile Selected");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserAvatar(
            profile: appState.activeProfile!,
            size: 70,
          ),
        ),
        Text(appState.activeProfile?.npubMetadata?.name ??
            appState.activeProfile!.label),
      ],
    );
  }
}

class SignButton extends StatelessWidget {
  const SignButton({
    super.key,
    required this.appState,
  });
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    void handleSignEvent() async {
      if (appState.scannedEvent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan an event first')),
        );
        return;
      }
      if (appState.activeProfile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a profile to sign with')),
        );
        return;
      }

      if (appState.relays.where((element) => element.isActive).isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active relays to publish to')),
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: handleSignEvent,
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 6.0),
                child: Icon(Icons.key),
              ),
              Text('Sign & Publish'),
            ],
          ),
        ),
      ],
    );
  }
}

class ScanButton extends StatelessWidget {
  const ScanButton({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ElevatedButton(
            onPressed: () {
              appState.navigate(Screen.scanner);
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Icon(Icons.qr_code_scanner),
                ),
                Text('Scan Event'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EventPreview extends StatelessWidget {
  const EventPreview({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  text: appState.prettyEventString),
            ),
          ),
        ),
      ),
    );
  }
}
