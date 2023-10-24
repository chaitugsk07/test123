part of 'set_like_view_comment_bloc.dart';

@immutable
abstract class SetLikeViewCommentEvent extends Equatable {
  const SetLikeViewCommentEvent();

  @override
  List<Object> get props => [];
}

class SetLikeViewCommentEventSetLike extends SetLikeViewCommentEvent {
  final int articleGroupId;
  final String action;

  const SetLikeViewCommentEventSetLike({
    required this.articleGroupId,
    required this.action,
  });

  @override
  List<Object> get props => [articleGroupId, action];
}

class ArticleCommentLikeSend extends SetLikeViewCommentEvent {
  final int commentId;
  const ArticleCommentLikeSend({required this.commentId});

  @override
  List<Object> get props => [commentId];
}

class ArticleCommentDisLikeSend extends SetLikeViewCommentEvent {
  final int commentId;
  const ArticleCommentDisLikeSend({required this.commentId});
  @override
  List<Object> get props => [commentId];
}

class ArticleCommentLikeDelete extends SetLikeViewCommentEvent {
  final int commentId;
  const ArticleCommentLikeDelete({required this.commentId});
  @override
  List<Object> get props => [commentId];
}

class ArticleCommentDisLikeDelete extends SetLikeViewCommentEvent {
  final int commentId;
  const ArticleCommentDisLikeDelete({required this.commentId});
  @override
  List<Object> get props => [commentId];
}

class ArticleCommentSet extends SetLikeViewCommentEvent {
  final int articleId;
  final String comment;
  const ArticleCommentSet(this.articleId, this.comment);
  @override
  List<Object> get props => [articleId, comment];
}

class ArticleCommentReplySet extends SetLikeViewCommentEvent {
  final int articleId;
  final String comment;
  final int commentId;
  const ArticleCommentReplySet(this.articleId, this.comment, this.commentId);
  @override
  List<Object> get props => [articleId, comment, commentId];
}
