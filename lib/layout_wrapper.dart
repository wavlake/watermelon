import 'package:flutter/material.dart';
import 'package:watermelon/model/constants.dart';
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
  bool showProfilePicker = false;

  /// accepts an optional boolean value, defaults to toggle
  void closeProfilePicker() {
    setState(() {
      showProfilePicker = false;
    });
  }

  void openProfilePicker() {
    setState(() {
      showProfilePicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = SafeArea(
      child: ColoredBox(
          color: WavlakeColors.beige,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.page,
                TextButton(
                    onPressed: () {
                      openProfilePicker();
                    },
                    child: const Text("Switch profile"))
              ],
            ),
          )),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              mainArea,
              if (showProfilePicker) ...[
                Opacity(
                  opacity: 0.4,
                  child: InkWell(
                    onTap: closeProfilePicker,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          const BoxDecoration(color: WavlakeColors.black),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration:
                            const BoxDecoration(color: WavlakeColors.mint),
                        child: SizedBox(
                          width: 350,
                          child: UserProfileScreen(
                            closeProfilePicker: closeProfilePicker,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
