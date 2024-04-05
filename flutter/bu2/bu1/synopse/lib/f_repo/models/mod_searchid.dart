class SynopseRealtimeGetEmbedding {
  SynopseRealtimeGetEmbedding({
    required this.id,
  });

  final int id;

  factory SynopseRealtimeGetEmbedding.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeGetEmbedding(
      id: json["id"] ?? 0,
    );
  }
}
