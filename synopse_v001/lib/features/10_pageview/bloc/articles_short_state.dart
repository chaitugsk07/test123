part of 'articles_short_bloc.dart';

class ArticleShortState extends Equatable {
  final List<ArticlesVArticlesMain> articlesVArticlesMain;
  final bool hasReachedMax;
  final ArticleShortStatus status;

  const ArticleShortState(
      {this.articlesVArticlesMain = const <ArticlesVArticlesMain>[],
      this.hasReachedMax = false,
      this.status = ArticleShortStatus.initial});

  ArticleShortState copyWith({
    List<ArticlesVArticlesMain>? articlesVArticlesMain,
    bool? hasReachedMax,
    ArticleShortStatus? status,
  }) {
    return ArticleShortState(
      articlesVArticlesMain:
          articlesVArticlesMain ?? this.articlesVArticlesMain,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesVArticlesMain, hasReachedMax, status];
}
