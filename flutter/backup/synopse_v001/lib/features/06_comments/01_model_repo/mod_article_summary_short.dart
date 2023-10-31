class ArticlesTV1ArticalsGroupsL1DetailSummaryShort {
  ArticlesTV1ArticalsGroupsL1DetailSummaryShort({
    required this.articleGroupId,
    required this.createdAt,
    required this.logoUrls,
    required this.imageUrls,
    required this.title,
    required this.summary60Words,
    required this.articleGroupsL1ToViews,
    required this.articleGroupsL1ToLikes,
    required this.articleGroupsL1ToComments,
    required this.tV1ArticalsGroupsL1ViewsLikes,
  });

  final int articleGroupId;
  final DateTime? createdAt;
  final List<String> logoUrls;
  final List<String> imageUrls;
  final String title;
  final String summary60Words;
  final ArticleGroupsL1ToViews? articleGroupsL1ToViews;
  final ArticleGroupsL1ToLikes? articleGroupsL1ToLikes;
  final ArticleGroupsL1ToComments? articleGroupsL1ToComments;
  final List<TV1ArticalsGroupsL1ViewsLike> tV1ArticalsGroupsL1ViewsLikes;

  factory ArticlesTV1ArticalsGroupsL1DetailSummaryShort.fromJson(
      Map<String, dynamic> json) {
    return ArticlesTV1ArticalsGroupsL1DetailSummaryShort(
      articleGroupId: json["article_group_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      title: json["title"] ?? "",
      summary60Words: json["summary_60_words"] ?? "",
      articleGroupsL1ToViews: json["article_groups_l1_to_views"] == null
          ? null
          : ArticleGroupsL1ToViews.fromJson(json["article_groups_l1_to_views"]),
      articleGroupsL1ToLikes: json["article_groups_l1_to_likes"] == null
          ? null
          : ArticleGroupsL1ToLikes.fromJson(json["article_groups_l1_to_likes"]),
      articleGroupsL1ToComments: json["article_groups_l1_to_comments"] == null
          ? null
          : ArticleGroupsL1ToComments.fromJson(
              json["article_groups_l1_to_comments"]),
      tV1ArticalsGroupsL1ViewsLikes:
          json["t_v1_articals_groups_l1_views_likes"] == null
              ? []
              : List<TV1ArticalsGroupsL1ViewsLike>.from(
                  json["t_v1_articals_groups_l1_views_likes"]!
                      .map((x) => TV1ArticalsGroupsL1ViewsLike.fromJson(x))),
    );
  }
}

class ArticleGroupsL1ToComments {
  ArticleGroupsL1ToComments({
    required this.commentCount,
  });

  final num commentCount;

  factory ArticleGroupsL1ToComments.fromJson(Map<String, dynamic> json) {
    return ArticleGroupsL1ToComments(
      commentCount: json["comment_count"] ?? 0,
    );
  }
}

class ArticleGroupsL1ToLikes {
  ArticleGroupsL1ToLikes({
    required this.likeCount,
  });

  final num likeCount;

  factory ArticleGroupsL1ToLikes.fromJson(Map<String, dynamic> json) {
    return ArticleGroupsL1ToLikes(
      likeCount: json["like_count"] ?? 0,
    );
  }
}

class ArticleGroupsL1ToViews {
  ArticleGroupsL1ToViews({
    required this.viewCount,
  });

  final num viewCount;

  factory ArticleGroupsL1ToViews.fromJson(Map<String, dynamic> json) {
    return ArticleGroupsL1ToViews(
      viewCount: json["view_count"] ?? 0,
    );
  }
}

class TV1ArticalsGroupsL1ViewsLike {
  TV1ArticalsGroupsL1ViewsLike({
    required this.type,
  });

  final num type;

  factory TV1ArticalsGroupsL1ViewsLike.fromJson(Map<String, dynamic> json) {
    return TV1ArticalsGroupsL1ViewsLike(
      type: json["type"] ?? 0,
    );
  }
}
