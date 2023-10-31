class ArticlesTV1ArticalsGroupsL1Comment {
  ArticlesTV1ArticalsGroupsL1Comment({
    required this.articleGroupId,
    required this.comments,
    required this.like,
    required this.dislike,
    required this.auth1User,
    required this.updatedAt,
  });

  final int articleGroupId;
  final String comments;
  final num like;
  final num dislike;
  final Auth1User? auth1User;
  final DateTime? updatedAt;

  factory ArticlesTV1ArticalsGroupsL1Comment.fromJson(
      Map<String, dynamic> json) {
    return ArticlesTV1ArticalsGroupsL1Comment(
      articleGroupId: json["article_group_id"] ?? 0,
      comments: json["comments"] ?? "",
      like: json["like"] ?? 0,
      dislike: json["dislike"] ?? 0,
      auth1User: json["auth1_user"] == null
          ? null
          : Auth1User.fromJson(json["auth1_user"]),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class Auth1User {
  Auth1User({
    required this.username,
    required this.userPhoto,
    required this.account,
  });

  final String username;
  final num userPhoto;
  final String account;

  factory Auth1User.fromJson(Map<String, dynamic> json) {
    return Auth1User(
      username: json["username"] ?? "",
      userPhoto: json["user_photo"] ?? 0,
      account: json["account"] ?? "",
    );
  }
}
