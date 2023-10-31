part of 'reply_comments_bloc.dart';

class ReplyCommentsState extends Equatable {
  final List<RealtimeVUserArticleComment> realtimeVUserArticleComment;
  final bool hasReachedMax;
  final ReplyCommentStatus status;

  const ReplyCommentsState(
      {this.realtimeVUserArticleComment = const <RealtimeVUserArticleComment>[],
      this.hasReachedMax = false,
      this.status = ReplyCommentStatus.initial});

  ReplyCommentsState copyWith({
    List<RealtimeVUserArticleComment>? realtimeVUserArticleComment,
    bool? hasReachedMax,
    ReplyCommentStatus? status,
  }) {
    return ReplyCommentsState(
      realtimeVUserArticleComment:
          realtimeVUserArticleComment ?? this.realtimeVUserArticleComment,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [realtimeVUserArticleComment, hasReachedMax, status];
}
