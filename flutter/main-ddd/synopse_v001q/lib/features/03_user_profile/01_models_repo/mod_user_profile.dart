class AuthAuth1User {
  AuthAuth1User({
    required this.account,
    required this.bio,
    required this.userPhoto,
    required this.username,
  });

  final String account;
  final String bio;
  final num userPhoto;
  final String username;

  factory AuthAuth1User.fromJson(Map<String, dynamic> json) {
    return AuthAuth1User(
      account: json["account"] ?? "",
      bio: json["bio"] ?? "",
      userPhoto: json["user_photo"] ?? 0,
      username: json["username"] ?? "",
    );
  }
}
