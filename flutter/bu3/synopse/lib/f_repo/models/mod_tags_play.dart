class SynopseArticlesTV7TagPlay {
  SynopseArticlesTV7TagPlay({
    required this.id,
    required this.filename,
    required this.tagName,
  });

  final int id;
  final String filename;
  final String tagName;

  factory SynopseArticlesTV7TagPlay.fromJson(Map<String, dynamic> json) {
    return SynopseArticlesTV7TagPlay(
      id: json["id"] ?? 0,
      filename: json["filename"] ?? "",
      tagName: json["tag_name"] ?? "",
    );
  }
}
