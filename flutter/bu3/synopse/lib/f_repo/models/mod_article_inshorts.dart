class SynopseArticlesTV4ArticleGroupsL2DetailInShorts {
  SynopseArticlesTV4ArticleGroupsL2DetailInShorts({
    required this.title,
    required this.imageUrls,
    required this.logoUrls,
    required this.articleGroupId,
    required this.keypoints,
    required this.groupAiTagsL3,
    required this.articleDetailLink,
  });

  final String title;
  final List<String> imageUrls;
  final List<String> logoUrls;
  final int articleGroupId;
  final List<String> keypoints;
  final String groupAiTagsL3;
  final ArticleDetailLink? articleDetailLink;

  factory SynopseArticlesTV4ArticleGroupsL2DetailInShorts.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesTV4ArticleGroupsL2DetailInShorts(
      title: json["title"] ?? "",
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      articleGroupId: json["article_group_id"] ?? 0,
      keypoints: json["keypoints"] == null
          ? []
          : List<String>.from(json["keypoints"]!.map((x) => x)),
      groupAiTagsL3: json["group_ai_tags_l3"] ?? "",
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
    required this.commentsCount,
    required this.viewsCount,
    required this.articleCount,
  });

  final String updatedAtFormatted;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final int articleCount;

  factory ArticleDetailLink.fromJson(Map<String, dynamic> json) {
    return ArticleDetailLink(
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      likesCount: json["likes_count"] ?? 0,
      commentsCount: json["comments_count"] ?? 0,
      viewsCount: json["views_count"] ?? 0,
      articleCount: json["article_count"] ?? 0,
    );
  }
}
