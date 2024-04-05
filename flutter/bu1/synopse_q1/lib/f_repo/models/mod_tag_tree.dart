class SynopseArticlesTV4TagsHierarchyTree {
  SynopseArticlesTV4TagsHierarchyTree({
    required this.tagId,
    required this.tag,
    required this.tagHierachy,
  });

  final int tagId;
  final String tag;
  final int tagHierachy;

  factory SynopseArticlesTV4TagsHierarchyTree.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesTV4TagsHierarchyTree(
      tagId: json["tag_id"] ?? 0,
      tag: json["tag"] ?? "",
      tagHierachy: json["tag_hierachy"] ?? 0,
    );
  }
}
