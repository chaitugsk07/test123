class Rss1ArticlesDetail {
  Rss1ArticlesDetail({
    required this.title,
    required this.imageLink,
    required this.discription,
  });

  final String title;
  final List<String> imageLink;
  final List<String> discription;

  factory Rss1ArticlesDetail.fromJson(Map<String, dynamic> json) {
    return Rss1ArticlesDetail(
      title: json["title"] ?? "",
      imageLink: json["image_link"] == null
          ? []
          : List<String>.from(json["image_link"]!.map((x) => x)),
      discription: json["discription"] == null
          ? []
          : List<String>.from(json["discription"]!.map((x) => x)),
    );
  }
}
