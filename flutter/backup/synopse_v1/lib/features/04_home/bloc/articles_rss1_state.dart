part of 'articles_rss1_bloc.dart';

class ArticlesRss1State extends Equatable {
  final List<ArticlesVArticleGroup> articlesVArticleGroup;
  final bool hasReachedMax;
  final ArticlesRss1Status status;

  const ArticlesRss1State(
      {this.articlesVArticleGroup = const <ArticlesVArticleGroup>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1Status.initial});

  ArticlesRss1State copyWith({
    List<ArticlesVArticleGroup>? articlesVArticleGroup,
    bool? hasReachedMax,
    ArticlesRss1Status? status,
  }) {
    return ArticlesRss1State(
      articlesVArticleGroup:
          articlesVArticleGroup ?? this.articlesVArticleGroup,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesVArticleGroup, hasReachedMax, status];
}
