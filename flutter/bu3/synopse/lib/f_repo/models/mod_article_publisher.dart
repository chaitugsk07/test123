class SynopseArticlesTV1Rss1ArticleF1 {
  SynopseArticlesTV1Rss1ArticleF1({
    required this.articleId,
    required this.imageLink,
    required this.postLink,
    required this.title,
    required this.tArticleMeta,
  });

  final int articleId;
  final String imageLink;
  final String postLink;
  final String title;
  final TArticleMeta? tArticleMeta;

  factory SynopseArticlesTV1Rss1ArticleF1.fromJson(Map<String, dynamic> json) {
    return SynopseArticlesTV1Rss1ArticleF1(
      articleId: json["article_id"] ?? 0,
      imageLink: json["image_link"] ?? "",
      postLink: json["post_link"] ?? "",
      title: json["title"] ?? "",
      tArticleMeta: json["t_article_meta"] == null
          ? null
          : TArticleMeta.fromJson(json["t_article_meta"]),
    );
  }
}

class TArticleMeta {
  TArticleMeta({
    required this.updatedAtFormatted,
  });

  final String updatedAtFormatted;

  factory TArticleMeta.fromJson(Map<String, dynamic> json) {
    return TArticleMeta(
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
    );
  }
}
