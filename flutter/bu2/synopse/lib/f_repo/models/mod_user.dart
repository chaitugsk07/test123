class SynopseRealtimeVUserMetadatum {
  SynopseRealtimeVUserMetadatum({
    required this.account,
    required this.memberSince,
    required this.userReputation,
    required this.userFollowing,
    required this.userFollowers,
    required this.userLikeCount,
    required this.userCommentCount,
    required this.userViewCount,
    required this.userToLevel,
  });

  final String account;
  final String memberSince;
  final int userReputation;
  final int userFollowing;
  final int userFollowers;
  final int userLikeCount;
  final int userCommentCount;
  final int userViewCount;
  final UserToLevel? userToLevel;

  factory SynopseRealtimeVUserMetadatum.fromJson(Map<String, dynamic> json) {
    return SynopseRealtimeVUserMetadatum(
      account: json["account"] ?? "",
      memberSince: json["member_since"] ?? "",
      userReputation: json["user_reputation"] ?? 0,
      userFollowing: json["user_following"] ?? 0,
      userFollowers: json["user_followers"] ?? 0,
      userLikeCount: json["user_like_count"] ?? 0,
      userCommentCount: json["user_comment_count"] ?? 0,
      userViewCount: json["user_view_count"] ?? 0,
      userToLevel: json["user_to_level"] == null
          ? null
          : UserToLevel.fromJson(json["user_to_level"]),
    );
  }
}

class UserToLevel {
  UserToLevel({
    required this.userLevelLink,
    required this.userToLink,
  });

  final UserLevelLink? userLevelLink;
  final UserToLink? userToLink;

  factory UserToLevel.fromJson(Map<String, dynamic> json) {
    return UserToLevel(
      userLevelLink: json["user_level_link"] == null
          ? null
          : UserLevelLink.fromJson(json["user_level_link"]),
      userToLink: json["user_to_link"] == null
          ? null
          : UserToLink.fromJson(json["user_to_link"]),
    );
  }
}

class UserLevelLink {
  UserLevelLink({
    required this.levelName,
  });

  final String levelName;

  factory UserLevelLink.fromJson(Map<String, dynamic> json) {
    return UserLevelLink(
      levelName: json["level_name"] ?? "",
    );
  }
}

class UserToLink {
  UserToLink({
    required this.bio,
    required this.name,
    required this.photourl,
    required this.username,
  });

  final dynamic bio;
  final String name;
  final String photourl;
  final String username;

  factory UserToLink.fromJson(Map<String, dynamic> json) {
    return UserToLink(
      bio: json["bio"] ?? "",
      name: json["name"] ?? "",
      photourl: json["photourl"] ?? "",
      username: json["username"] ?? "",
    );
  }
}
