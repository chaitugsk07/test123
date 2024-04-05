class SynopseArticlesVArticlesGroupDetailsSearch {
  SynopseArticlesVArticlesGroupDetailsSearch({
    required this.articleGroupId,
    required this.articleGroup,
  });

  final int articleGroupId;
  final ArticleGroup? articleGroup;

  factory SynopseArticlesVArticlesGroupDetailsSearch.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesVArticlesGroupDetailsSearch(
      articleGroupId: json["article_group_id"] ?? 0,
      articleGroup: json["article_group"] == null
          ? null
          : ArticleGroup.fromJson(json["article_group"]),
    );
  }
}

class ArticleGroup {
  ArticleGroup({
    required this.title,
    required this.imageUrls,
    required this.logoUrls,
    required this.articleDetailLink,
    required this.tUserArticleCommentsAggregate,
    required this.tUserArticleLikesAggregate,
    required this.tUserArticleViewsAggregate,
  });

  final String title;
  final List<String> imageUrls;
  final List<String> logoUrls;
  final ArticleDetailLink? articleDetailLink;
  final TUserArticleSAggregate? tUserArticleCommentsAggregate;
  final TUserArticleSAggregate? tUserArticleLikesAggregate;
  final TUserArticleSAggregate? tUserArticleViewsAggregate;

  factory ArticleGroup.fromJson(Map<String, dynamic> json) {
    return ArticleGroup(
      title: json["title"] ?? "",
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      articleDetailLink: json["article_detail_link"] == null
          ? null
          : ArticleDetailLink.fromJson(json["article_detail_link"]),
      tUserArticleCommentsAggregate:
          json["t_user_article_comments_aggregate"] == null
              ? null
              : TUserArticleSAggregate.fromJson(
                  json["t_user_article_comments_aggregate"]),
      tUserArticleLikesAggregate: json["t_user_article_likes_aggregate"] == null
          ? null
          : TUserArticleSAggregate.fromJson(
              json["t_user_article_likes_aggregate"]),
      tUserArticleViewsAggregate: json["t_user_article_views_aggregate"] == null
          ? null
          : TUserArticleSAggregate.fromJson(
              json["t_user_article_views_aggregate"]),
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

class TUserArticleSAggregate {
  TUserArticleSAggregate({
    required this.aggregate,
  });

  final Aggregate? aggregate;

  factory TUserArticleSAggregate.fromJson(Map<String, dynamic> json) {
    return TUserArticleSAggregate(
      aggregate: json["aggregate"] == null
          ? null
          : Aggregate.fromJson(json["aggregate"]),
    );
  }
}

class Aggregate {
  Aggregate({
    required this.count,
  });

  final int count;

  factory Aggregate.fromJson(Map<String, dynamic> json) {
    return Aggregate(
      count: json["count"] ?? 0,
    );
  }
}
