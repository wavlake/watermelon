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

  setLabel(String label) {
    label = label;
  }

  String npub;
  String label;
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
