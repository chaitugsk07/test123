class SynopseRealtimeVUserArticleComment {
  SynopseRealtimeVUserArticleComment({
    required this.comment,
    required this.id,
    required this.commentsLikeCount,
    required this.commentsReplyCount,
    required this.updatedAtFormatted,
    required this.commentsDislikeCount,
    required this.isEdited,
    required this.photourl,
    required this.account,
    required this.articleGroupId,
    required this.username,
    required this.name,
    required this.articleCommentDislikesAggregate,
    required this.articleCommentLikesAggregate,
    required this.userCommentReplyCount,
  });

  final String comment;
  final int id;
  final int commentsLikeCount;
  final int commentsReplyCount;
  final String updatedAtFormatted;
  final int commentsDislikeCount;
  final int isEdited;
  final String photourl;
  final String account;
  final int articleGroupId;
  final String username;
  final String name;
  final ArticleCommentLikesAggregate? articleCommentDislikesAggregate;
  final ArticleCommentLikesAggregate? articleCommentLikesAggregate;
  final UserCommentReplyCount? userCommentReplyCount;

  factory SynopseRealtimeVUserArticleComment.fromJson(
      Map<String, dynamic> json) {
    return SynopseRealtimeVUserArticleComment(
      comment: json["comment"] ?? "",
      id: json["id"] ?? 0,
      commentsLikeCount: json["comments_like_count"] ?? 0,
      commentsReplyCount: json["comments_reply_count"] ?? 0,
      updatedAtFormatted: json["updated_at_formatted"] ?? "",
      commentsDislikeCount: json["comments_dislike_count"] ?? 0,
      isEdited: json["is_edited"] ?? 0,
      photourl: json["photourl"] ?? "",
      account: json["account"] ?? "",
      articleGroupId: json["article_group_id"] ?? 0,
      username: json["username"] ?? "",
      name: json["name"] ?? "",
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
