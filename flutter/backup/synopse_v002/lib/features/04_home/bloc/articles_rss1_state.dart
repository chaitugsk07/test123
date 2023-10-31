part of 'articles_rss1_bloc.dart';

class ArticlesRss1State extends Equatable {
  final List<ArticlesTV1ArticalsGroupsL1Detail>
      articlesTV1ArticalsGroupsL1Detail;
  final bool hasReachedMax;
  final ArticlesRss1Status status;

  const ArticlesRss1State(
      {this.articlesTV1ArticalsGroupsL1Detail =
          const <ArticlesTV1ArticalsGroupsL1Detail>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1Status.initial});

  ArticlesRss1State copyWith({
    List<ArticlesTV1ArticalsGroupsL1Detail>? articlesTV1ArticalsGroupsL1Detail,
    bool? hasReachedMax,
    ArticlesRss1Status? status,
  }) {
    return ArticlesRss1State(
      articlesTV1ArticalsGroupsL1Detail: articlesTV1ArticalsGroupsL1Detail ??
          this.articlesTV1ArticalsGroupsL1Detail,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [articlesTV1ArticalsGroupsL1Detail, hasReachedMax, status];
}
