class SynopseArticlesTV4ArticleGroupsL2DetailNoLogin {
  SynopseArticlesTV4ArticleGroupsL2DetailNoLogin({
    required this.title,
    required this.articleGroupId,
    required this.imageUrls,
    required this.logoUrls,
    required this.articleDetailLink,
  });

  final String title;
  final int articleGroupId;
  final List<String> imageUrls;
  final List<String> logoUrls;
  final ArticleDetailLink? articleDetailLink;

  factory SynopseArticlesTV4ArticleGroupsL2DetailNoLogin.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesTV4ArticleGroupsL2DetailNoLogin(
      title: json["title"] ?? "",
      articleGroupId: json["article_group_id"] ?? 0,
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      articleDetailLink: json["article_detail_link"] == null
          ? null
          : ArticleDetailLink.fromJson(json["article_detail_link"]),
    );
  }
}

class ArticleDetailLink {
  ArticleDetailLink({
    required this.updatedAtFormatted,
    required this.likesCount,
    required this.viewsCount,
    required this.commentsCount,
    required this.articleCount,
  });

  final String updatedAtFormatted;
  final int likesCount;
  final int viewsCount;
  final int commentsCount;
  final int articleCount;

  factory ArticleDetailLink.fromJson(Map<String, dynamic> json) {
    return ArticleDetailLink(
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      likesCount: json["likes_count"] ?? 0,
      viewsCount: json["views_count"] ?? 0,
      commentsCount: json["comments_count"] ?? 0,
      articleCount: json["article_count"] ?? 0,
    );
  }
}
