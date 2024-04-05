class SynopseRealtimeTUserTag {
  SynopseRealtimeTUserTag({
    required this.tagId,
  });

  final int tagId;

  factory SynopseRealtimeTUserTag.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeTUserTag(
      tagId: json["tag_id"] ?? 0,
    );
  }
}
