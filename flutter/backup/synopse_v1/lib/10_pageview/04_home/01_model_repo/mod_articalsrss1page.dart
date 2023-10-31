class ArticlesTV1ArticalsGroupsL1DetailPage {
  ArticlesTV1ArticalsGroupsL1DetailPage({
    required this.articleGroupId,
    required this.updatedAt,
    required this.title,
    required this.summary60Words,
    required this.logoUrls,
    required this.imageUrls,
  });

  final int articleGroupId;
  final DateTime? updatedAt;
  final String title;
  final String summary60Words;
  final List<String> logoUrls;
  final List<String> imageUrls;

  factory ArticlesTV1ArticalsGroupsL1DetailPage.fromJson(
      Map<String, dynamic> json) {
    return ArticlesTV1ArticalsGroupsL1DetailPage(
      articleGroupId: json["article_group_id"] ?? 0,
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      title: json["title"] ?? "",
      summary60Words: json["summary_60_words"] ?? "",
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
    );
  }
}
