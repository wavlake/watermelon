import 'package:flutter/material.dart';

class UrlInput extends StatefulWidget {
  UrlInput({
    super.key,
    required this.relayUrlController,
    required this.url,
  });

  TextEditingController relayUrlController;
  String url;

  @override
  State<UrlInput> createState() => _UrlInputState();
}

class _UrlInputState extends State<UrlInput> {
  @override
  Widget build(BuildContext context) {
    widget.relayUrlController.text = widget.url;

    return SizedBox(
        height: 35,
        width: 200,
        child: TextFormField(
            controller: widget.relayUrlController,
            decoration:
                const InputDecoration(contentPadding: EdgeInsets.all(5))));
  }
}
