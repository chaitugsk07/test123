part of 'article_comments_bloc.dart';

class ArticleCommentsState extends Equatable {
  final List<RealtimeVUserArticleComment> realtimeVUserArticleComment;
  final bool hasReachedMax;
  final ArticlesCommentStatus status;

  const ArticleCommentsState(
      {this.realtimeVUserArticleComment = const <RealtimeVUserArticleComment>[],
      this.hasReachedMax = false,
      this.status = ArticlesCommentStatus.initial});

  ArticleCommentsState copyWith({
    List<RealtimeVUserArticleComment>? realtimeVUserArticleComment,
    bool? hasReachedMax,
    ArticlesCommentStatus? status,
  }) {
    return ArticleCommentsState(
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
