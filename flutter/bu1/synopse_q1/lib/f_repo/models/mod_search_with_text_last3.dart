class SynopseRealtimeTTempUserSearchWithText {
  SynopseRealtimeTTempUserSearchWithText({
    required this.text,
  });

  final String text;

  factory SynopseRealtimeTTempUserSearchWithText.fromJson(
      Map<String, dynamic> json) {
    return SynopseRealtimeTTempUserSearchWithText(
      text: json["text"] ?? "",
    );
  }
}
