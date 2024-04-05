class SynopseArticlesTV4TagsHierarchyRootForYou {
  SynopseArticlesTV4TagsHierarchyRootForYou({
    required this.tagId,
    required this.tag,
  });

  final int tagId;
  final String tag;

  factory SynopseArticlesTV4TagsHierarchyRootForYou.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesTV4TagsHierarchyRootForYou(
      tagId: json["tag_id"] ?? 0,
      tag: json["tag"] ?? "",
    );
  }
}
