import 'dart:ui';

import 'package:flutter/material.dart';

enum Screen {
  welcome,
  addUserProfile,
  signing,
  scanner,
  loading,
  editUserProfile,
  editRelay,
  addRelay,
}

/// deprecated keys
const storageKeyPrivateHex = "privateHexKey";
const storageKeyUserProfiles = "userPrivateProfiles";

String wavlakeRelay = "wss://relay.wavlake.com";

const secureNpubNsecMap = "npubNsecMap";
const publicProfileInfo = "userProfiles";
const publicRelayList = "relayList";
const hasSeenWelcomeScreen = "hasSeenWelcomeScreen";

const Map<Screen, bool> shouldShowProfileSwitchButton = {
  Screen.welcome: false,
  Screen.addUserProfile: false,
  Screen.signing: true,
  Screen.scanner: true,
  Screen.loading: false,
  Screen.editUserProfile: false,
  Screen.addRelay: false,
  Screen.editRelay: false,
};

// https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
abstract class WavlakeColors {
  static const Color pink = Color(0xFFf3aef2);
  static const Color purple = Color(0xFFba9bf9);
  static const Color beige = Color(0xFFfff6f1);
  static const Color highlight = Color(0xFFfffff2);
  static const Color orange = Color(0xFFffb848);
  static const Color mint = Color(0xFF5bdeb1);
  static const Color black = Color(0xFF171817);
  static const Color red = Color(0xFFff4949);
  // new color that isnt used in other apps
  static const Color lightBlack = Color(0xFF303230);
}
