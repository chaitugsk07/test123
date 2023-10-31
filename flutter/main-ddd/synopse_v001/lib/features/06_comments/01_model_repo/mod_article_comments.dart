class RealtimeVUserArticleComment {
  RealtimeVUserArticleComment({
    required this.articleGroupId,
    required this.id,
    required this.comment,
    required this.commentsDislikeCount,
    required this.commentsLikeCount,
    required this.commentsReplyCount,
    required this.updatedAtFormatted,
    required this.isEdited,
    required this.commentsToUsers,
    required this.commentToUserLike,
    required this.commentToUserDislike,
  });

  final int articleGroupId;
  final int id;
  final String comment;
  final num commentsDislikeCount;
  final num commentsLikeCount;
  final num commentsReplyCount;
  final String updatedAtFormatted;
  final num isEdited;
  final CommentsToUsers? commentsToUsers;
  final CommentToUserLike? commentToUserLike;
  final CommentToUserLike? commentToUserDislike;

  factory RealtimeVUserArticleComment.fromJson(Map<String, dynamic> json) {
    return RealtimeVUserArticleComment(
      articleGroupId: json["article_group_id"] ?? 0,
      id: json["id"] ?? 0,
      comment: json["comment"] ?? "",
      commentsDislikeCount: json["comments_dislike_count"] ?? 0,
      commentsLikeCount: json["comments_like_count"] ?? 0,
      commentsReplyCount: json["comments_reply_count"] ?? 0,
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      isEdited: json["is_edited"] ?? 0,
      commentsToUsers: json["comments_to_users"] == null
          ? null
          : CommentsToUsers.fromJson(json["comments_to_users"]),
      commentToUserLike: json["comment_to_user_like"] == null
          ? null
          : CommentToUserLike.fromJson(json["comment_to_user_like"]),
      commentToUserDislike: json["comment_to_user_dislike"] == null
          ? null
          : CommentToUserLike.fromJson(json["comment_to_user_dislike"]),
    );
  }
}

class CommentToUserLike {
  CommentToUserLike({
    required this.commentId,
  });

  final int commentId;

  factory CommentToUserLike.fromJson(Map<String, dynamic> json) {
    return CommentToUserLike(
      commentId: json["comment_id"] ?? 0,
    );
  }
}

class CommentsToUsers {
  CommentsToUsers({
    required this.account,
    required this.bio,
    required this.userPhoto,
    required this.username,
  });

  final String account;
  final String bio;
  final num userPhoto;
  final String username;

  factory CommentsToUsers.fromJson(Map<String, dynamic> json) {
    return CommentsToUsers(
      account: json["account"] ?? "",
      bio: json["bio"] ?? "",
      userPhoto: json["user_photo"] ?? 0,
      username: json["username"] ?? "",
    );
  }
}
