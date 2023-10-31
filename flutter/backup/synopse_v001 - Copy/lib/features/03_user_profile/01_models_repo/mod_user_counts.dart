class UserCounts {
  UserCounts({
    required this.views,
    required this.likes,
    required this.comments,
    required this.followers,
    required this.following,
  });

  final num views;
  final num likes;
  final num comments;
  final num followers;
  final num following;

  factory UserCounts.fromJson(Map<String, dynamic> json) {
    return UserCounts(
      views: json["views"] ?? 0,
      likes: json["likes"] ?? 0,
      comments: json["comments"] ?? 0,
      followers: json["followers"] ?? 0,
      following: json["following"] ?? 0,
    );
  }
}
