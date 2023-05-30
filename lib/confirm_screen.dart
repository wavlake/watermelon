import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/profile.dart';

class ConfrimScreen extends StatelessWidget {
 const ConfrimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<Profile>();

    return const Placeholder();
  }
}
