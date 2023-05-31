import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nostr_tools/nostr_tools.dart';

import 'model/profile.dart';


class KeyEntryScreen extends StatelessWidget {
  const KeyEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<Profile>();
    var abbreviatedNpub = appState.npubKey.length > 12 ? appState.npubKey.substring(0,12) : "";

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        title: const Text('Wavlake'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Form(
        key: appState.formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      "Welcome to wavlake, if you already have a nostr key, please enter it below, otherwise, please click on the button below to generate a new key"),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
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
                          return 'Please enter your nsec';
                        }

                        if (!appState.isValidNsec(value)) return 'Please enter a valid nsec';
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (appState.formKey.currentState!.validate()) {
                                appState.savePrivateHex();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                      Text('Error submitting your nsec')
                                  ),
                                );
                              }
                            },
                            child: const Text('Save Nsec'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: appState.generateNewNsec,
                            child: const Text('Generate new nsec'),
                          ),
                          ElevatedButton(
                            onPressed: appState.readPrivateHex,
                            child: const Text('Read saved nsec'),
                          ),
                          ElevatedButton(
                            onPressed: appState.deletePrivateHex,
                            child: const Text('Delete saved nsec'),
                          ),
                          // if there is an npub, show it
                          if (abbreviatedNpub != "") Text("npub: $abbreviatedNpub"),
                        ]),
                  ),
                ],
              ))),
    );
  }
}

  Widget getTextWidgets(List<String> strings, deleteKey)
  {
    List<Widget> list = List<Widget>.empty(growable: true);
    for(var i = 0; i < strings.length; i++){
      var nsec = strings[i];
      list.add(
        Row(
          children: [
            Text(nsec.substring(0,12)),
            ElevatedButton(
              onPressed: () => deleteKey(i),
              child: const Text('Delete'),
            ),
          ]
        )
      );
    }
    return Column(children: list);
  }
