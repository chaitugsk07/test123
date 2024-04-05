class SynopseRealtimeTUserTagUI {
  SynopseRealtimeTUserTagUI({
    required this.tV4TagsHierarchy,
  });

  final TV4TagsHierarchy? tV4TagsHierarchy;

  factory SynopseRealtimeTUserTagUI.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeTUserTagUI(
      tV4TagsHierarchy: json["t_v4_tags_hierarchy"] == null
          ? null
          : TV4TagsHierarchy.fromJson(json["t_v4_tags_hierarchy"]),
    );
  }
}

class TV4TagsHierarchy {
  TV4TagsHierarchy({
    required this.tag,
  });

  final String tag;

  factory TV4TagsHierarchy.fromJson(Map<String, dynamic> json) {
    return TV4TagsHierarchy(
      tag: json["tag"] ?? "",
    );
  }
}
