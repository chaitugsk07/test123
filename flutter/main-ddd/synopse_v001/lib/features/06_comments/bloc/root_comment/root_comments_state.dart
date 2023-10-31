part of 'root_comments_bloc.dart';

class RootCommentsState extends Equatable {
  final List<RealtimeVUserArticleComment> realtimeVUserArticleComment;
  final RootCommentStatus status;

  const RootCommentsState(
      {this.realtimeVUserArticleComment = const <RealtimeVUserArticleComment>[],
      this.status = RootCommentStatus.initial});

  RootCommentsState copyWith({
    List<RealtimeVUserArticleComment>? realtimeVUserArticleComment,
    RootCommentStatus? status,
  }) {
    return RootCommentsState(
      realtimeVUserArticleComment:
          realtimeVUserArticleComment ?? this.realtimeVUserArticleComment,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [realtimeVUserArticleComment, status];
}
