class UserProfile {
  // nsec is marked as required since we dont have a default value like isActive
  UserProfile(
      {required this.npub,
      required this.label,
      this.isActive = false,
      String? profileUrl}) {
    npub = npub;
    isActive = isActive;
    label = label;
    profileUrl = profileUrl;
  }

  setActive(bool active) {
    isActive = active;
  }

  setLabel(String newLabel) {
    label = newLabel;
  }

  setProfileUrl(String newProfileUrl) {
    profileUrl = newProfileUrl;
  }

  String npub;
  String label;
  String? profileUrl;
  String defaultProfileUrl = "assets/wavlake.png";
  bool isActive;

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
      profileUrl: json['profileUrl'],
    );
  }
}
