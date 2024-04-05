class SynopseRealtimeVUserArticleCommentUser {
  SynopseRealtimeVUserArticleCommentUser({
    required this.comment,
    required this.id,
    required this.updatedAtFormatted,
    required this.commentsLikeCount,
    required this.commentsDislikeCount,
    required this.commentToArticleGroup,
  });

  final String comment;
  final int id;
  final String updatedAtFormatted;
  final int commentsLikeCount;
  final int commentsDislikeCount;
  final CommentToArticleGroup? commentToArticleGroup;

  factory SynopseRealtimeVUserArticleCommentUser.fromJson(
      Map<String, dynamic> json) {
    return SynopseRealtimeVUserArticleCommentUser(
      comment: json["comment"] ?? "",
      id: json["id"] ?? 0,
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      commentsLikeCount: json["comments_like_count"] ?? 0,
      commentsDislikeCount: json["comments_dislike_count"] ?? 0,
      commentToArticleGroup: json["comment_to_article_group"] == null
          ? null
          : CommentToArticleGroup.fromJson(json["comment_to_article_group"]),
    );
  }
}

class CommentToArticleGroup {
  CommentToArticleGroup({
    required this.title,
    required this.articleGroupId,
  });

  final String title;
  final int articleGroupId;

  factory CommentToArticleGroup.fromJson(Map<String, dynamic> json) {
    return CommentToArticleGroup(
      title: json["title"] ?? "",
      articleGroupId: json["article_group_id"] ?? 0,
    );
  }
}
