class ArticlesVArticleGroup {
  ArticlesVArticleGroup({
    required this.articleGroupId,
    required this.title,
    required this.logoUrls,
    required this.imageUrls,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.updatedAt,
  });

  final int articleGroupId;
  final String title;
  final List<String> logoUrls;
  final List<String> imageUrls;
  final num viewCount;
  final num likeCount;
  final num commentCount;
  final DateTime? updatedAt;

  factory ArticlesVArticleGroup.fromJson(Map<String, dynamic> json) {
    return ArticlesVArticleGroup(
      articleGroupId: json["article_group_id"] ?? 0,
      title: json["title"] ?? "",
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      viewCount: json["view_count"] ?? 0,
      likeCount: json["like_count"] ?? 0,
      commentCount: json["comment_count"] ?? 0,
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

/*
{
	"data": {
		"articles_v_article_group": [
			{
				"article_group_id": 54,
				"title": " Niger military wants ‘negotiated framework’ for French army pullout",
				"logo_urls": [
					"https://i.postimg.cc/26x7kWCp/Fox-News-Channel-logo-svg-1.png",
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/8i5fbc/article67350417.ece/alternates/LANDSCAPE_1200/AFP_33WH3PN.jpg",
					"https://a57.foxnews.com/static.foxnews.com/foxnews.com/content/uploads/2023/01/931/523/DOTCOM_STATE_COUNTRY_NEWS_AFRICA.png?ve=1&tl=1",
					"https://th-i.thgim.com/public/incoming/ygq1vx/article67354598.ece/alternates/LANDSCAPE_1200/IMG_FILES-NIGER-FRANCE-C_2_1_HNBPUQOA.jpg"
				],
				"view_count": 2,
				"like_count": 2,
				"comment_count": 1,
				"updated_at": "2023-10-02T07:18:55.844349+00:00"
			},
		]
	}
}*/