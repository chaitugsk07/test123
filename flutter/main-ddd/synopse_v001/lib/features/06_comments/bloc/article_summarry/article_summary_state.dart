part of 'article_summary_bloc.dart';

class ArticleSummaryShortState extends Equatable {
  final List<ArticlesVArticlesMain> articlesVArticlesMain;
  final ArticlesSummaryStatusStatus status;

  const ArticleSummaryShortState(
      {this.articlesVArticlesMain = const <ArticlesVArticlesMain>[],
      this.status = ArticlesSummaryStatusStatus.initial});

  ArticleSummaryShortState copyWith({
    List<ArticlesVArticlesMain>? articlesVArticlesMain,
    ArticlesSummaryStatusStatus? status,
  }) {
    return ArticleSummaryShortState(
      articlesVArticlesMain:
          articlesVArticlesMain ?? this.articlesVArticlesMain,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesVArticlesMain, status];
}
