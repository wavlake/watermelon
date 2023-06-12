import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import '../../model/relay.dart';
import '../../model/state.dart';
import 'url_input.dart';

class RelayRow extends StatefulWidget {
  RelayRow(
      {super.key,
      required this.relay,
      this.isEditing = false,
      this.isNewRow = false,
      required this.hideAddRelayRow});

  final Relay relay;
  final TextEditingController relayUrlController = TextEditingController();
  final bool isNewRow;
  final Function() hideAddRelayRow;
  bool isEditing;

  @override
  State<RelayRow> createState() => _RelayRowState();
}

class _RelayRowState extends State<RelayRow> {
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
              Checkbox(
                value: widget.relay.isActive,
                onChanged: (value) {
                  appState.setActiveRelay(widget.relay, value);
                },
              ),
              widget.isEditing
                  ? UrlInput(
                      relayUrlController: widget.relayUrlController,
                      url: widget.relay.url)
                  : Text(widget.relay.url),
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    if (widget.isEditing) {
                      if (widget.isNewRow) {
                        // adding a new relay
                        appState.addRelay(widget.relayUrlController.text);
                      } else {
                        // editing an existing relay
                        appState.editRelay(
                            widget.relay, widget.relayUrlController.text);
                      }
                      widget.hideAddRelayRow();
                    } else {
                      setState(() {
                        widget.isEditing = !widget.isEditing;
                      });
                    }
                  },
                  child: Icon(
                    widget.isEditing ? Icons.save : Icons.edit,
                    color: WavlakeColors.mint,
                    size: 20.0,
                  )),
              TextButton(
                  onPressed: () async {
                    await appState.deleteRelay(widget.relay);
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
