class SynopseArticlesTV1Rss1Article {
  SynopseArticlesTV1Rss1Article({
    required this.imageLink,
    required this.postLink,
    required this.title,
    required this.tV1Outlet,
  });

  final String imageLink;
  final String postLink;
  final String title;
  final TV1Outlet? tV1Outlet;

  factory SynopseArticlesTV1Rss1Article.fromJson(Map<String, dynamic> json) {
    return SynopseArticlesTV1Rss1Article(
      imageLink: json["image_link"] ?? "",
      postLink: json["post_link"] ?? "",
      title: json["title"] ?? "",
      tV1Outlet: json["t_v1_outlet"] == null
          ? null
          : TV1Outlet.fromJson(json["t_v1_outlet"]),
    );
  }
}

class TV1Outlet {
  TV1Outlet({
    required this.logoUrl,
    required this.outletDisplay,
  });

  final String logoUrl;
  final String outletDisplay;

  factory TV1Outlet.fromJson(Map<String, dynamic> json) {
    return TV1Outlet(
      logoUrl: json["logo_url"] ?? "",
      outletDisplay: json["outlet_display"] ?? "",
    );
  }
}
