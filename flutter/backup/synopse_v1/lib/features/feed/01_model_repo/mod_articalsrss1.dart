class Rss1Artical {
  Rss1Artical({
    required this.postLink,
    required this.imageLink,
    required this.title,
    required this.summary,
    required this.author,
    required this.isDefaultImage,
    required this.postPublished,
    required this.rss1LinkByRss1Link,
  });

  final String postLink;
  final String imageLink;
  final String title;
  final String summary;
  final String author;
  final num isDefaultImage;
  final DateTime? postPublished;
  final Rss1LinkByRss1Link? rss1LinkByRss1Link;

  factory Rss1Artical.fromJson(Map<String, dynamic> json) {
    return Rss1Artical(
      postLink: json["post_link"] ?? "",
      imageLink: json["image_link"] ?? "",
      title: json["title"] ?? "",
      summary: json["summary"] ?? "",
      author: json["author"] ?? "",
      isDefaultImage: json["is_default_image"] ?? 0,
      postPublished: DateTime.tryParse(json["post_published"] ?? ""),
      rss1LinkByRss1Link: json["rss1LinkByRss1Link"] == null
          ? null
          : Rss1LinkByRss1Link.fromJson(json["rss1LinkByRss1Link"]),
    );
  }
}

class Rss1LinkByRss1Link {
  Rss1LinkByRss1Link({
    required this.outlet,
    required this.rss1LinkName,
    required this.rss1Outlet,
  });

  final String outlet;
  final String rss1LinkName;
  final Rss1Outlet? rss1Outlet;

  factory Rss1LinkByRss1Link.fromJson(Map<String, dynamic> json) {
    return Rss1LinkByRss1Link(
      outlet: json["outlet"] ?? "",
      rss1LinkName: json["rss1_link_name"] ?? "",
      rss1Outlet: json["rss1_outlet"] == null
          ? null
          : Rss1Outlet.fromJson(json["rss1_outlet"]),
    );
  }
}

class Rss1Outlet {
  Rss1Outlet({
    required this.logoUrl,
    required this.outletDisplay,
  });

  final String logoUrl;
  final String outletDisplay;

  factory Rss1Outlet.fromJson(Map<String, dynamic> json) {
    return Rss1Outlet(
      logoUrl: json["logo_url"] ?? "",
      outletDisplay: json["outlet_display"] ?? "",
    );
  }
}
