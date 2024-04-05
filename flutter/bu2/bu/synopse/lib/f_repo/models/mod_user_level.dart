class SynopseRealtimeVUserLevel {
  SynopseRealtimeVUserLevel({
    required this.account,
    required this.levelNo,
    required this.requiredPoints,
    required this.userReputation,
    required this.userLevelLink,
    required this.userToLink,
    required this.userMetadata,
  });

  final String account;
  final int levelNo;
  final int requiredPoints;
  final int userReputation;
  final UserLevelLink? userLevelLink;
  final UserToLink? userToLink;
  final UserMetadata? userMetadata;

  factory SynopseRealtimeVUserLevel.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeVUserLevel(
      account: json["account"] ?? "",
      levelNo: json["level_no"] ?? 0,
      requiredPoints: json["required_points"] ?? 0,
      userReputation: json["user_reputation"] ?? 0,
      userLevelLink: json["user_level_link"] == null
          ? null
          : UserLevelLink.fromJson(json["user_level_link"]),
      userToLink: json["user_to_link"] == null
          ? null
          : UserToLink.fromJson(json["user_to_link"]),
      userMetadata: json["user_metadata"] == null
          ? null
          : UserMetadata.fromJson(json["user_metadata"]),
    );
  }
}

class UserLevelLink {
  UserLevelLink({
    required this.levelName,
    required this.levelNo,
    required this.userReputationTo,
  });

  final String levelName;
  final int levelNo;
  final int userReputationTo;

  factory UserLevelLink.fromJson(Map<String, dynamic> json) {
    return UserLevelLink(
      levelName: json["level_name"] ?? "",
      levelNo: json["level_no"] ?? 0,
      userReputationTo: json["user_reputation_to"] ?? 0,
    );
  }
}

class UserMetadata {
  UserMetadata({
    required this.memberSince,
  });

  final String memberSince;

  factory UserMetadata.fromJson(Map<String, dynamic> json) {
    return UserMetadata(
      memberSince: json["member_since"] ?? "",
    );
  }
}

class UserToLink {
  UserToLink({
    required this.username,
  });

  final String username;

  factory UserToLink.fromJson(Map<String, dynamic> json) {
    return UserToLink(
      username: json["username"] ?? "",
    );
  }
}
