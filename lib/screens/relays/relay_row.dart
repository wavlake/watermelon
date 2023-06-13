import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import '../../components/delete_relay_dialog.dart';
import '../../model/relay.dart';
import '../../model/state.dart';

class RelayRow extends StatelessWidget {
  const RelayRow(
      {super.key, required this.relay, required this.closeRelayPicker});

  final Relay relay;
  final void Function() closeRelayPicker;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // TODO - add checkbox to make active/inactive
              // Checkbox(
              //   value: widget.relay.isActive,
              //   onChanged: (value) {
              //     if (value != null) return;
              //     appState.setActiveRelay(widget.relay, value!);
              //   },
              // ),
              Text(relay.url),
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    closeRelayPicker();
                    appState.setEditingRelay(relay);
                    appState.navigate(Screen.editRelay);
                  },
                  child: const Icon(
                    Icons.edit,
                    color: WavlakeColors.mint,
                    size: 20.0,
                  )),
              TextButton(
                  onPressed: () {
                    deleteRelayDialog(context, relay, closeRelayPicker);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: WavlakeColors.red,
                    size: 20.0,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
