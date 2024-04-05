class SynopseArticlesTV4TagsHierarchyRoot {
  SynopseArticlesTV4TagsHierarchyRoot({
    required this.tag,
    required this.tagId,
    required this.tagsHierarchy,
  });

  final String tag;
  final int tagId;
  final List<TagsHierarchy> tagsHierarchy;

  factory SynopseArticlesTV4TagsHierarchyRoot.fromJson(
      Map<String, dynamic> json) {
    return SynopseArticlesTV4TagsHierarchyRoot(
      tag: json["tag"] ?? "",
      tagId: json["tag_id"] ?? 0,
      tagsHierarchy: json["tags_hierarchy"] == null
          ? []
          : List<TagsHierarchy>.from(
              json["tags_hierarchy"]!.map((x) => TagsHierarchy.fromJson(x))),
    );
  }
}

class TagsHierarchy {
  TagsHierarchy({
    required this.tagId,
    required this.tag,
    required this.tagHierachy,
    required this.userToTagAggregate,
  });

  final int tagId;
  final String tag;
  final int tagHierachy;
  final UserToTagAggregate? userToTagAggregate;

  factory TagsHierarchy.fromJson(Map<String, dynamic> json) {
    return TagsHierarchy(
      tagId: json["tag_id"] ?? 0,
      tag: json["tag"] ?? "",
      tagHierachy: json["tag_hierachy"] ?? 0,
      userToTagAggregate: json["user_to_tag_aggregate"] == null
          ? null
          : UserToTagAggregate.fromJson(json["user_to_tag_aggregate"]),
    );
  }
}

class UserToTagAggregate {
  UserToTagAggregate({
    required this.aggregate,
  });

  final Aggregate? aggregate;

  factory UserToTagAggregate.fromJson(Map<String, dynamic> json) {
    return UserToTagAggregate(
      aggregate: json["aggregate"] == null
          ? null
          : Aggregate.fromJson(json["aggregate"]),
    );
  }
}

class Aggregate {
  Aggregate({
    required this.count,
  });

  final int count;

  factory Aggregate.fromJson(Map<String, dynamic> json) {
    return Aggregate(
      count: json["count"] ?? 0,
    );
  }
}
