import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watermelon/model/constants.dart';

import '../../model/relay.dart';
import '../../model/state.dart';

class RelayRow extends StatefulWidget {
  RelayRow({super.key, required this.relay, this.isEditing = true});

  final Relay relay;
  final TextEditingController relayUrlController = TextEditingController();
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
                  ? SizedBox(
                      height: 40,
                      width: 200,
                      child: TextFormField(
                        controller: widget.relayUrlController,
                      ),
                    )
                  : Text(widget.relay.url),
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () => {
                        setState(() {
                          widget.isEditing = !widget.isEditing;
                        })
                      },
                  child: Icon(
                    widget.isEditing ? Icons.save : Icons.edit,
                    color: WavlakeColors.mint,
                    size: 20.0,
                  )),
              TextButton(
                  onPressed: () async {
                    print("delete relay");
                    await appState.deleteRelay(widget.relay);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: WavlakeColors.orange,
                    size: 20.0,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
