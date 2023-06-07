import 'package:flutter/material.dart';

import '../../components.dart';
import '../../model/state.dart';

class AddAccountForm extends StatelessWidget {
  const AddAccountForm({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: appState.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TopBackButton(
              title: "Add an Account",
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NsecInput(appState: appState),
                  ElevatedButton(
                    onPressed: () {
                      if (appState.formKey.currentState!.validate()) {
                        appState.addNewProfile();
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
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextButton(
                      onPressed: appState.generateNewNsec,
                      child: const Text("Generate a new key")),
                ),
              ],
            ),
          ],
        ));
  }
}

class NsecInput extends StatefulWidget {
  const NsecInput({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  State<NsecInput> createState() => _NsecInputState();
}

class _NsecInputState extends State<NsecInput> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TextFormField(
        controller: widget.appState.nsecController,
        obscureText: isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "nsec",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscured = !isObscured;
              });
            },
            icon: isObscured
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Key is required';
          }
          if (!widget.appState.isValidNsec(value)) {
            return 'Please enter a valid key';
          }

          return null;
        },
      ),
    );
  }
}
