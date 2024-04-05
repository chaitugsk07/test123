class SynopseRealtimeVV10UsersFollowUp {
  SynopseRealtimeVV10UsersFollowUp({
    required this.query,
    required this.reply,
  });

  final String query;
  final String reply;

  factory SynopseRealtimeVV10UsersFollowUp.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeVV10UsersFollowUp(
      query: json["query"] ?? "",
      reply: json["reply"] ?? "",
    );
  }
}
