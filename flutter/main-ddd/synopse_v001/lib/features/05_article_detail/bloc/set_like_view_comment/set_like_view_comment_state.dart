part of 'set_like_view_comment_bloc.dart';

class SetLikeViewCommentState extends Equatable {
  final SetLikeViewCommentStatus status;

  const SetLikeViewCommentState(
      {this.status = SetLikeViewCommentStatus.initial});

  SetLikeViewCommentState copyWith({
    SetLikeViewCommentStatus? status,
  }) {
    return SetLikeViewCommentState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
