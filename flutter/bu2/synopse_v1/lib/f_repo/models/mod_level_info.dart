class SynopseRealtimeTUserLevel {
  SynopseRealtimeTUserLevel({
    required this.levelNo,
    required this.levelName,
    required this.levelInfo,
    required this.userReputationFrom,
    required this.userReputationTo,
  });

  final int levelNo;
  final String levelName;
  final String levelInfo;
  final int userReputationFrom;
  final int userReputationTo;

  factory SynopseRealtimeTUserLevel.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeTUserLevel(
      levelNo: json["level_no"] ?? 0,
      levelName: json["level_name"] ?? "",
      levelInfo: json["level_info"] ?? "",
      userReputationFrom: json["user_reputation_from"] ?? 0,
      userReputationTo: json["user_reputation_to"] ?? 0,
    );
  }
}
