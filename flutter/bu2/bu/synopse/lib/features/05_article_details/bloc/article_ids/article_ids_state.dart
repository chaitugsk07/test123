part of 'article_ids_bloc.dart';

class ArticleIdsState extends Equatable {
  final List<SynopseArticlesTV1Rss1Article> synopseArticlesTV1Rss1Article;
  final ArticleIdsStatus status;

  const ArticleIdsState(
      {this.synopseArticlesTV1Rss1Article =
          const <SynopseArticlesTV1Rss1Article>[],
      this.status = ArticleIdsStatus.initial});

  ArticleIdsState copyWith({
    List<SynopseArticlesTV1Rss1Article>? synopseArticlesTV1Rss1Article,
    ArticleIdsStatus? status,
  }) {
    return ArticleIdsState(
      synopseArticlesTV1Rss1Article:
          synopseArticlesTV1Rss1Article ?? this.synopseArticlesTV1Rss1Article,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseArticlesTV1Rss1Article, status];
}
