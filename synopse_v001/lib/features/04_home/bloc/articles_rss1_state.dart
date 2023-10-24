part of 'articles_rss1_bloc.dart';

class ArticlesRss1State extends Equatable {
  final List<ArticlesVArticlesMain> articlesVArticlesMain;
  final bool hasReachedMax;
  final ArticlesRss1Status status;

  const ArticlesRss1State(
      {this.articlesVArticlesMain = const <ArticlesVArticlesMain>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1Status.initial});

  ArticlesRss1State copyWith({
    List<ArticlesVArticlesMain>? articlesVArticlesMain,
    bool? hasReachedMax,
    ArticlesRss1Status? status,
  }) {
    return ArticlesRss1State(
      articlesVArticlesMain:
          articlesVArticlesMain ?? this.articlesVArticlesMain,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesVArticlesMain, hasReachedMax, status];
}
