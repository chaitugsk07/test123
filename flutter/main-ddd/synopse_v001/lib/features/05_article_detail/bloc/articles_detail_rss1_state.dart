part of 'articles_detail_rss1_bloc.dart';

class ArticleDetailState extends Equatable {
  final List<ArticlesVArticlesMain> articlesVArticlesMain;
  final bool hasReachedMax;
  final ArticlesRss1StatusDetail status;

  const ArticleDetailState(
      {this.articlesVArticlesMain = const <ArticlesVArticlesMain>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1StatusDetail.initial});

  ArticleDetailState copyWith({
    List<ArticlesVArticlesMain>? articlesVArticlesMain,
    bool? hasReachedMax,
    ArticlesRss1StatusDetail? status,
  }) {
    return ArticleDetailState(
      articlesVArticlesMain:
          articlesVArticlesMain ?? this.articlesVArticlesMain,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesVArticlesMain, hasReachedMax, status];
}
