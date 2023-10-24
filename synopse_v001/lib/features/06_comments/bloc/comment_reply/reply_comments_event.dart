part of 'reply_comments_bloc.dart';

@immutable
abstract class ReplyCommentsEvent extends Equatable {
  const ReplyCommentsEvent();
  @override
  List<Object?> get props => [];
}

class ReplyCommentsFetch extends ReplyCommentsEvent {
  final int commentId;

  const ReplyCommentsFetch({required this.commentId});
}

class ReplyCommentsRefresh extends ReplyCommentsEvent {
  const ReplyCommentsRefresh();
}

class ReplyCommentsSend extends ReplyCommentsEvent {
  const ReplyCommentsSend();
}
