class SynopseRealtimeVUserArticleCommentUser {
  SynopseRealtimeVUserArticleCommentUser({
    required this.comment,
    required this.id,
    required this.commentsLikeCount,
    required this.commentsReplyCount,
    required this.updatedAtFormatted,
    required this.commentsDislikeCount,
    required this.isEdited,
    required this.articleGroupId,
    required this.account,
    required this.articleCommentDislikesAggregate,
    required this.articleCommentLikesAggregate,
    required this.userCommentReplyCount,
    required this.commentToArticleGroup,
  });

  final String comment;
  final int id;
  final int commentsLikeCount;
  final int commentsReplyCount;
  final String updatedAtFormatted;
  final int commentsDislikeCount;
  final int isEdited;
  final int articleGroupId;
  final String account;
  final ArticleCommentLikesAggregate? articleCommentDislikesAggregate;
  final ArticleCommentLikesAggregate? articleCommentLikesAggregate;
  final UserCommentReplyCount? userCommentReplyCount;
  final CommentToArticleGroup? commentToArticleGroup;

  factory SynopseRealtimeVUserArticleCommentUser.fromJson(
      Map<String, dynamic> json) {
    return SynopseRealtimeVUserArticleCommentUser(
      comment: json["comment"] ?? "",
      id: json["id"] ?? 0,
      commentsLikeCount: json["comments_like_count"] ?? 0,
      commentsReplyCount: json["comments_reply_count"] ?? 0,
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      commentsDislikeCount: json["comments_dislike_count"] ?? 0,
      isEdited: json["is_edited"] ?? 0,
      articleGroupId: json["article_group_id"] ?? 0,
      account: json["account"] ?? "",
      articleCommentDislikesAggregate:
          json["article_comment_dislikes_aggregate"] == null
              ? null
              : ArticleCommentLikesAggregate.fromJson(
                  json["article_comment_dislikes_aggregate"]),
      articleCommentLikesAggregate:
          json["article_comment_likes_aggregate"] == null
              ? null
              : ArticleCommentLikesAggregate.fromJson(
                  json["article_comment_likes_aggregate"]),
      userCommentReplyCount: json["user_comment_reply_count"] == null
          ? null
          : UserCommentReplyCount.fromJson(json["user_comment_reply_count"]),
      commentToArticleGroup: json["comment_to_article_group"] == null
          ? null
          : CommentToArticleGroup.fromJson(json["comment_to_article_group"]),
    );
  }
}

class ArticleCommentLikesAggregate {
  ArticleCommentLikesAggregate({
    required this.aggregate,
  });

  final Aggregate? aggregate;

  factory ArticleCommentLikesAggregate.fromJson(Map<String, dynamic> json) {
    return ArticleCommentLikesAggregate(
      aggregate: json["aggregate"] == null
          ? null
          : Aggregate.fromJson(json["aggregate"]),
    );
  }
}

class Aggregate {
  Aggregate({
    required this.count,
  });

  final int count;

  factory Aggregate.fromJson(Map<String, dynamic> json) {
    return Aggregate(
      count: json["count"] ?? 0,
    );
  }
}

class CommentToArticleGroup {
  CommentToArticleGroup({
    required this.title,
  });

  final String title;

  factory CommentToArticleGroup.fromJson(Map<String, dynamic> json) {
    return CommentToArticleGroup(
      title: json["title"] ?? "",
    );
  }
}

class UserCommentReplyCount {
  UserCommentReplyCount({
    required this.replyComment,
  });

  final int replyComment;

  factory UserCommentReplyCount.fromJson(Map<String, dynamic> json) {
    return UserCommentReplyCount(
      replyComment: json["reply_comment"] ?? 0,
    );
  }
}
