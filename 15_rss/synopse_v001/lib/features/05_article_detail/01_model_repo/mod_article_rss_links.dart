class ArticlesTV1Rss1Artical {
  ArticlesTV1Rss1Artical({
    required this.postLink,
    required this.postPublished,
    required this.title,
    required this.imageLink,
    required this.tV1Rss1FeedLink,
  });

  final String postLink;
  final DateTime? postPublished;
  final String title;
  final String imageLink;
  final TV1Rss1FeedLink? tV1Rss1FeedLink;

  factory ArticlesTV1Rss1Artical.fromJson(Map<String, dynamic> json) {
    return ArticlesTV1Rss1Artical(
      postLink: json["post_link"] ?? "",
      postPublished: DateTime.tryParse(json["post_published"] ?? ""),
      title: json["title"] ?? "",
      imageLink: json["image_link"] ?? "",
      tV1Rss1FeedLink: json["t_v1_rss1_feed_link"] == null
          ? null
          : TV1Rss1FeedLink.fromJson(json["t_v1_rss1_feed_link"]),
    );
  }
}

class TV1Rss1FeedLink {
  TV1Rss1FeedLink({
    required this.tV1Outlet,
  });

  final TV1Outlet? tV1Outlet;

  factory TV1Rss1FeedLink.fromJson(Map<String, dynamic> json) {
    return TV1Rss1FeedLink(
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
