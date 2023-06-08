class UserProfile {
  // nsec is marked as required since we dont have a default value like isActive
  UserProfile(
      {required this.npub, required this.label, bool? isActive = false}) {
    // var privateHex = _nip19.decode(nsec)['data'];
    // var publicHex = _keyGenerator.getPublicKey(privateHex);
    npub = npub;
    isActive = isActive;
    label = label;
  }

  setActive(bool active) {
    isActive = active;
  }

  setLabel(String newLabel) {
    label = newLabel;
  }

  String npub;
  String label;
  // fake profile image url, update to pull from relay
  // https://github.com/nostr-protocol/nips/blob/master/01.md#basic-event-kinds
  String profileUrl = "https://i.pravatar.cc/200";
  bool isActive = false;

  Map<String, dynamic> toJson() {
    return {
      "npub": npub,
      "isActive": isActive,
      "label": label,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      npub: json['npub'],
      isActive: json['isActive'],
      label: json['label'],
    );
  }
}
