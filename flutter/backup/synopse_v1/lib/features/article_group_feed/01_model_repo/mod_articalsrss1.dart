class ArticlesTV1ArticalsGroupsL1Detail {
    ArticlesTV1ArticalsGroupsL1Detail({
        required this.title,
        required this.logoUrls,
        required this.imageUrls,
        required this.articleGroupId,
        required this.updatedAt,
    });

    final String title;
    final List<String> logoUrls;
    final List<String> imageUrls;
    final int articleGroupId;
    final DateTime? updatedAt;

    factory ArticlesTV1ArticalsGroupsL1Detail.fromJson(Map<String, dynamic> json){ 
        return ArticlesTV1ArticalsGroupsL1Detail(
            title: json["title"] ?? "",
            logoUrls: json["logo_urls"] == null ? [] : List<String>.from(json["logo_urls"]!.map((x) => x)),
            imageUrls: json["image_urls"] == null ? [] : List<String>.from(json["image_urls"]!.map((x) => x)),
            articleGroupId: json["article_group_id"] ?? 0,
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "title": title,
        "logo_urls": logoUrls.map((x) => x).toList(),
        "image_urls": imageUrls.map((x) => x).toList(),
        "article_group_id": articleGroupId,
        "updated_at": updatedAt?.toIso8601String(),
    };

}