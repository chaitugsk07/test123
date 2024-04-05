class SynopseRealtimeTTempUserSearch {
  SynopseRealtimeTTempUserSearch({
    required this.search,
    required this.id,
  });

  final String search;
  final int id;

  factory SynopseRealtimeTTempUserSearch.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeTTempUserSearch(
      search: json["search"] ?? "",
      id: json["id"] ?? 0,
    );
  }
}
