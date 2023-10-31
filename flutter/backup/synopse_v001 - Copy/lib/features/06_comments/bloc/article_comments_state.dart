part of 'article_comments_bloc.dart';

class ArticleCommentsState extends Equatable {
  final List<ArticlesTV1ArticalsGroupsL1Comment>
      articlesTV1ArticalsGroupsL1Comment;
  final bool hasReachedMax;
  final ArticlesCommentStatus status;

  const ArticleCommentsState(
      {this.articlesTV1ArticalsGroupsL1Comment =
          const <ArticlesTV1ArticalsGroupsL1Comment>[],
      this.hasReachedMax = false,
      this.status = ArticlesCommentStatus.initial});

  ArticleCommentsState copyWith({
    List<ArticlesTV1ArticalsGroupsL1Comment>?
        articlesTV1ArticalsGroupsL1Comment,
    bool? hasReachedMax,
    ArticlesCommentStatus? status,
  }) {
    return ArticleCommentsState(
      articlesTV1ArticalsGroupsL1Comment: articlesTV1ArticalsGroupsL1Comment ??
          this.articlesTV1ArticalsGroupsL1Comment,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [articlesTV1ArticalsGroupsL1Comment, hasReachedMax, status];
}
