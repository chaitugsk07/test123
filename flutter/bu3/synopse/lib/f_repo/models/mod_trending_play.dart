class SynopseArticlesTV7AllArticleSummary8Hour {
  SynopseArticlesTV7AllArticleSummary8Hour({
    required this.filename,
    required this.id,
    required this.summary,
  });

  final String filename;
  final int id;
  final String summary;

  factory SynopseArticlesTV7AllArticleSummary8Hour.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesTV7AllArticleSummary8Hour(
      filename: json["filename"] ?? "",
      id: json["id"] ?? 0,
      summary: json["summary"] ?? "",
    );
  }
}
