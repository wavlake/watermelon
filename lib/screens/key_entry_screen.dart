import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/profile.dart';

class KeyEntryScreen extends StatelessWidget {
  const KeyEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<Profile>();

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        title: const Text('Wavlake'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Form(
          key: appState.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(onPressed: null, child: Icon(Icons.arrow_back)),
                  Text("Add New Account")
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Welcome to wavlake, if you already have a nostr key, please enter it below, otherwise, please click on the button below to generate a new key"),
                  TextFormField(
                    controller: appState.nsecController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "nsec",
                      suffixIcon: IconButton(
                        onPressed: appState.clearNsecField,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Key is required';
                      }
                      if (!appState.isValidNsec(value)) {
                        return 'Please enter a valid key';
                      }

                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (appState.formKey.currentState!.validate()) {
                        appState.savePrivateHex();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Key')),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

Widget getTextWidgets(List<String> strings, deleteKey) {
  List<Widget> list = List<Widget>.empty(growable: true);
  for (var i = 0; i < strings.length; i++) {
    var nsec = strings[i];
    list.add(Row(children: [
      Text(nsec.substring(0, 12)),
      ElevatedButton(
        onPressed: () => deleteKey(i),
        child: const Text('Delete'),
      ),
    ]));
  }
  return Column(children: list);
}

// a Text widget that returns an npub or nothing if null
class NpubTextWidget extends StatelessWidget {
  final String text;
  const NpubTextWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text != "" && text.isNotEmpty) return Text(text);

    // if no npub, return "nothing"
    // https://stackoverflow.com/questions/53455358/how-to-present-an-empty-view-in-flutter
    return const SizedBox.shrink();
  }
}
