import 'package:flutter/material.dart';
import '../../model/profiles.dart';
import '../../model/state.dart';

// This is currently not used anywhere, but it's a good example of how to create a custom button.
class WavlakeIconButton extends StatelessWidget {
  const WavlakeIconButton({
    super.key,
    required this.appState,
    required this.profile,
    required this.icon,
    this.onPressed,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.size = 20,
  });

  final AppState appState;
  final UserProfile profile;
  final IconData icon;
  final void Function()? onPressed;
  final double opacity;
  final MaterialColor color;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (onPressed != null) {
      return TextButton(
        onPressed: () {
          appState.makeProfileActive(profile);
        },
        child: Opacity(
          opacity: opacity,
          child: Icon(
            icon,
            color: color,
            size: size,
          ),
        ),
      );
    }

    return Opacity(
      opacity: 0.3,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
