part of 'articles_detail_rss1_bloc.dart';

class ArticleDetailState extends Equatable {
  final List<ArticlesTV1ArticalsGroupsL1DetailSummary>
      articlesTV1ArticalsGroupsL1DetailSummary;
  final bool hasReachedMax;
  final ArticlesRss1StatusDetail status;

  const ArticleDetailState(
      {this.articlesTV1ArticalsGroupsL1DetailSummary =
          const <ArticlesTV1ArticalsGroupsL1DetailSummary>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1StatusDetail.initial});

  ArticleDetailState copyWith({
    List<ArticlesTV1ArticalsGroupsL1DetailSummary>?
        articlesTV1ArticalsGroupsL1DetailSummary,
    bool? hasReachedMax,
    ArticlesRss1StatusDetail? status,
  }) {
    return ArticleDetailState(
      articlesTV1ArticalsGroupsL1DetailSummary:
          articlesTV1ArticalsGroupsL1DetailSummary ??
              this.articlesTV1ArticalsGroupsL1DetailSummary,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [articlesTV1ArticalsGroupsL1DetailSummary, hasReachedMax, status];
}
