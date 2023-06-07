import 'package:flutter/material.dart';
import '/screens/userProfile/user_profile_screen.dart';

class LayoutWrapper extends StatefulWidget {
  const LayoutWrapper({
    super.key,
    required this.page,
  });
  final Widget page;

  @override
  State<LayoutWrapper> createState() => _LayoutWrapperState();
}

class _LayoutWrapperState extends State<LayoutWrapper> {
  bool showProfilePicker = true;

  void toggleProfilePicker() {
    setState(() {
      showProfilePicker = !showProfilePicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Watermelon signing app"),
                  widget.page,
                  TextButton(
                      onPressed: () {
                        toggleProfilePicker();
                      },
                      child: const Text("Switch profile"))
                ],
              ),
              if (showProfilePicker)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.pink),
                        child: SizedBox(
                          width: 350,
                          child: UserProfileScreen(
                            closeProfilePicker: toggleProfilePicker,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          )),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(child: mainArea);
        },
      ),
    );
  }
}
