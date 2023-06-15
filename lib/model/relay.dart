class Relay {
  Relay({
    required this.url,
    this.isActive = true,
  }) {
    url = url;
    isActive = isActive;
  }

  setActive(bool active) {
    isActive = active;
  }

  setUrl(String newUrl) {
    url = newUrl;
  }

  String url;
  bool isActive;

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "isActive": isActive,
    };
  }

  factory Relay.fromJson(Map<String, dynamic> json) {
    return Relay(
      url: json['url'],
      isActive: json['isActive'],
    );
  }
}
