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
    required this.commentToUserComment,
    required this.commentToArticleGroup,
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
  final CommentToUserComment? commentToUserComment;
  final CommentToArticleGroup? commentToArticleGroup;

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
      commentToUserComment: json["comment_to_user_comment"] == null
          ? null
          : CommentToUserComment.fromJson(json["comment_to_user_comment"]),
      commentToArticleGroup: json["comment_to_article_group"] == null
          ? null
          : CommentToArticleGroup.fromJson(json["comment_to_article_group"]),
    );
  }
}

class CommentToArticleGroup {
  CommentToArticleGroup({
    required this.title,
    required this.logoUrls,
  });

  final String title;
  final List<String> logoUrls;

  factory CommentToArticleGroup.fromJson(Map<String, dynamic> json) {
    return CommentToArticleGroup(
      title: json["title"] ?? "",
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
    );
  }
}

class CommentToUserComment {
  CommentToUserComment({
    required this.tUserCommentLikesAggregate,
    required this.tUserCommentDislikesAggregate,
    required this.userCommentReplyCount,
    required this.isEdited,
  });

  final TUserCommentLikesAggregate? tUserCommentLikesAggregate;
  final TUserCommentLikesAggregate? tUserCommentDislikesAggregate;
  final UserCommentReplyCount? userCommentReplyCount;
  final int isEdited;

  factory CommentToUserComment.fromJson(Map<String, dynamic> json) {
    return CommentToUserComment(
      tUserCommentLikesAggregate: json["t_user_comment_likes_aggregate"] == null
          ? null
          : TUserCommentLikesAggregate.fromJson(
              json["t_user_comment_likes_aggregate"]),
      tUserCommentDislikesAggregate:
          json["t_user_comment_dislikes_aggregate"] == null
              ? null
              : TUserCommentLikesAggregate.fromJson(
                  json["t_user_comment_dislikes_aggregate"]),
      userCommentReplyCount: json["user_comment_reply_count"] == null
          ? null
          : UserCommentReplyCount.fromJson(json["user_comment_reply_count"]),
      isEdited: json["is_edited"] ?? 0,
    );
  }
}

class TUserCommentLikesAggregate {
  TUserCommentLikesAggregate({
    required this.aggregate,
  });

  final Aggregate? aggregate;

  factory TUserCommentLikesAggregate.fromJson(Map<String, dynamic> json) {
    return TUserCommentLikesAggregate(
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
