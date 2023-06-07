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

    return Form(
        key: appState.formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(appState.prettyEventString),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
              ),
            ]));
  }
}
