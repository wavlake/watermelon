class Relay {
  Relay({
    required this.url,
    bool? isActive = true,
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
  bool isActive = false;

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
