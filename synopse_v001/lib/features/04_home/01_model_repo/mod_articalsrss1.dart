class ArticlesVArticlesMain {
  ArticlesVArticlesMain({
    required this.articleGroupId,
    required this.title,
    required this.logoUrls,
    required this.imageUrls,
    required this.likesCount,
    required this.viewsCount,
    required this.commentsCount,
    required this.updatedAtFormatted,
    required this.articlesLikes,
    required this.articlesViews,
    required this.articleToGroup,
    required this.summary,
    required this.summary60Words,
    required this.updatedAt,
    required this.monthsSinceUpdated,
    required this.daysSinceUpdated,
  });

  final int articleGroupId;
  final String title;
  final List<String> logoUrls;
  final List<String> imageUrls;
  final num likesCount;
  final num viewsCount;
  final num commentsCount;
  final String updatedAtFormatted;
  final Articles? articlesLikes;
  final Articles? articlesViews;
  final ArticleToGroup? articleToGroup;
  final String summary;
  final String summary60Words;
  final DateTime? updatedAt;
  final num monthsSinceUpdated;
  final num daysSinceUpdated;

  factory ArticlesVArticlesMain.fromJson(Map<String, dynamic> json) {
    return ArticlesVArticlesMain(
      articleGroupId: json["article_group_id"] ?? 0,
      title: json["title"] ?? "",
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      likesCount: json["likes_count"] ?? 0,
      viewsCount: json["views_count"] ?? 0,
      commentsCount: json["comments_count"] ?? 0,
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      articlesLikes: json["articles_likes"] == null
          ? null
          : Articles.fromJson(json["articles_likes"]),
      articlesViews: json["articles_views"] == null
          ? null
          : Articles.fromJson(json["articles_views"]),
      articleToGroup: json["article_to_group"] == null
          ? null
          : ArticleToGroup.fromJson(json["article_to_group"]),
      summary: json["summary"] ?? "",
      summary60Words: json["summary_60_words"] ?? "",
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      monthsSinceUpdated: json["months_since_updated"] ?? 0,
      daysSinceUpdated: json["days_since_updated"] ?? 0,
    );
  }
}

class ArticleToGroup {
  ArticleToGroup({
    required this.articlesGroup,
  });

  final List<num> articlesGroup;

  factory ArticleToGroup.fromJson(Map<String, dynamic> json) {
    return ArticleToGroup(
      articlesGroup: json["articles_group"] == null
          ? []
          : List<num>.from(json["articles_group"]!.map((x) => x)),
    );
  }
}

class Articles {
  Articles({
    required this.articleGroupId,
  });

  final int articleGroupId;

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      articleGroupId: json["article_group_id"] ?? 0,
    );
  }
}
