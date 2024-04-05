class SynopseRealtimeTUserArticleBookmark {
  SynopseRealtimeTUserArticleBookmark({
    required this.articleGroupId,
    required this.tV4ArticleGroupsL2Detail,
  });

  final int articleGroupId;
  final TV4ArticleGroupsL2Detail? tV4ArticleGroupsL2Detail;

  factory SynopseRealtimeTUserArticleBookmark.fromJson(
      Map<String, dynamic> json) {
    return SynopseRealtimeTUserArticleBookmark(
      articleGroupId: json["article_group_id"] ?? 0,
      tV4ArticleGroupsL2Detail: json["t_v4_article_groups_l2_detail"] == null
          ? null
          : TV4ArticleGroupsL2Detail.fromJson(
              json["t_v4_article_groups_l2_detail"]),
    );
  }
}

class TV4ArticleGroupsL2Detail {
  TV4ArticleGroupsL2Detail({
    required this.title,
    required this.imageUrls,
    required this.logoUrls,
  });

  final String title;
  final List<String> imageUrls;
  final List<String> logoUrls;

  factory TV4ArticleGroupsL2Detail.fromJson(Map<String, dynamic> json) {
    return TV4ArticleGroupsL2Detail(
      title: json["title"] ?? "",
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
    );
  }
}
