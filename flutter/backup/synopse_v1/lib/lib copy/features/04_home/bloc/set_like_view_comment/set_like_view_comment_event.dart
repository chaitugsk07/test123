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
