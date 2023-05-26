import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nostr_tools/nostr_tools.dart';

import 'model/profile.dart';


class KeyEntryScreen extends StatelessWidget {
  const KeyEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<Profile>();

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        title: Text('Wavlake'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Form(
          key: appState.formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Welcome to wavlake, if you already have a nostr key, please enter it below, otherwise, please click on the button below to generate a new key"),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: appState.nsecController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "nsec"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your nsec';
                        }

                        bool validatePrivateHexKey (String value) {
                          try {
                            final nip19 = Nip19();
                            var privateHexKey = nip19.decode(value);
                            print(privateHexKey);
                            if (privateHexKey['type'] != 'nsec') {
                              print('Invalid nsec type');
                              return false;
                            }
                            return true;
                          } catch (e) {
                            print('Invalid nsec catch $e');
                            return false;
                          }
                        }
                        if (!validatePrivateHexKey(value) && value.length != 64) {
                          return 'Please enter a valid nsec';
                        }
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
                                          Text('Error submitting your nsec')),
                                );
                              }
                            },
                            child: const Text('SaveSecret'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: appState.generateNewNsec,
                            child: const Text('Generate new key'),
                          ),
                          ElevatedButton(
                            onPressed: appState.getStoredNsecs,
                            child: const Text('Update Nsecs'),
                          ),
                          ElevatedButton(
                            onPressed: appState.deleteAllSecrets,
                            child: const Text('Delete all secrets'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ]),
                  ),
                  getTextWidgets(appState.nsecs, appState.deleteKey),
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
