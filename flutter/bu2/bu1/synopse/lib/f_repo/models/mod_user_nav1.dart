class SynopseAuthTAuthUserProfile {
  SynopseAuthTAuthUserProfile({
    required this.nav1,
  });

  final List<Nav1> nav1;

  factory SynopseAuthTAuthUserProfile.fromJson(Map<String, dynamic> json) {
    return SynopseAuthTAuthUserProfile(
      nav1: json["nav1"] == null
          ? []
          : List<Nav1>.from(json["nav1"]!.map((x) => Nav1.fromJson(x))),
    );
  }
}

class Nav1 {
  Nav1({
    required this.type,
    required this.index1,
    required this.index2,
    required this.tabItem,
  });

  final int type;
  final int index1;
  final int index2;
  final String tabItem;

  factory Nav1.fromJson(Map<String, dynamic> json) {
    return Nav1(
      type: json["type"] ?? 0,
      index1: json["index1"] ?? 0,
      index2: json["index2"] ?? 0,
      tabItem: json["tabItem"] ?? "",
    );
  }
}
