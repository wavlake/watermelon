import 'package:nostr_tools/nostr_tools.dart';
import 'dart:convert';

final _nip19 = Nip19();

class UserProfile {
  // nsec is marked as required since we dont have a default value like isActive
  UserProfile({
    required this.npub,
    required this.label,
    this.isActive = false,
    this.npubMetadata,
    String? profileUrl,
  }) {
    npub = npub;
    isActive = isActive;
    label = label;
    profileUrl = profileUrl;
    npubMetadata = npubMetadata;
  }

  setActive(bool active) {
    isActive = active;
  }

  setNpubMetadata(NpubMetadata data) {
    npubMetadata = data;
  }

  setLabel(String newLabel) {
    label = newLabel;
  }

  setProfileUrl(String newProfileUrl) {
    profileUrl = newProfileUrl;
  }

  String get pubhex => _nip19.decode(npub)['data'];

  String npub;
  String label;
  String? profileUrl;
  NpubMetadata? npubMetadata;
  String defaultProfileUrl = "assets/wavlake-icon-96.png";
  bool isActive;

  Map<String, dynamic> toJson() {
    return {
      "npub": npub,
      "isActive": isActive,
      "label": label,
      "npubMetadata": npubMetadata?.toJson(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      npub: json['npub'],
      isActive: json['isActive'],
      label: json['label'],
      profileUrl: json['profileUrl'],
      npubMetadata: json['npubMetadata'] == null
          ? null
          : NpubMetadata.fromJson(json['npubMetadata']),
    );
  }
}

// https://github.com/nostr-protocol/nips/blob/master/01.md#basic-event-kinds
class NpubMetadata {
  NpubMetadata({
    this.picture = "assets/wavlake-icon-96.png",
    this.name,
    required this.createdAt,
  }) {
    picture = picture;
    name = name;
    createdAt = createdAt;
  }

  String picture;
  String? name;
  int createdAt;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "picture": picture,
      "createdAt": createdAt,
    };
  }

  factory NpubMetadata.fromJson(Map<String, dynamic> json) {
    return NpubMetadata(
      name: json['name'],
      picture: json['picture'],
      createdAt: json['createdAt'],
    );
  }
}
