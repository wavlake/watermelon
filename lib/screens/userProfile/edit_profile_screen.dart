import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/components/backup_key_dialog.dart';
import 'package:watermelon/components/top_back_button.dart';
import 'package:flutter/services.dart';

import '../../model/state.dart';
import 'label_input.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // profile list view
    return Form(
      key: appState.editProfileForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TopBackButton(
            title: "Edit Profile",
          ),
          Column(
            children: [
              NpubText(appState: appState),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: LabelInput(appState: appState),
              ),
              ElevatedButton(
                  onPressed: appState.saveLabel, child: const Text("Save")),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      backupKeyDialog(context, appState.editingProfile!);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.key),
                        ),
                        Text("Backup Keys"),
                      ],
                    )),
              ),
            ],
          ),
          // this is to force the widget above to be centered
          const SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }
}

class NpubText extends StatefulWidget {
  const NpubText({
    super.key,
    required this.appState,
  });

  final AppState appState;
  @override
  State<NpubText> createState() => _NpubTextState();
}

class _NpubTextState extends State<NpubText> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    if (widget.appState.editingProfile == null) {
      return const Text("Error loading npub...");
    }
    String npub = widget.appState.editingProfile!.npub;

    void clipboardCopy() {
      Clipboard.setData(ClipboardData(text: npub));
      setState(() {
        isCopied = true;
      });
      // set time out to reset the isCopied state
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isCopied = false;
        });
      });
    }

    ;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: clipboardCopy,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${npub.substring(0, 11)}...${npub.substring(npub.length - 7, npub.length)}"),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(isCopied ? Icons.check : Icons.copy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
