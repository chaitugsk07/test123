part of 'article_summary_bloc.dart';

class ArticleSummaryShortState extends Equatable {
  final List<ArticlesTV1ArticalsGroupsL1DetailSummaryShort>
      articlesTV1ArticalsGroupsL1DetailSummaryShort;
  final ArticlesSummaryStatusStatus status;

  const ArticleSummaryShortState(
      {this.articlesTV1ArticalsGroupsL1DetailSummaryShort =
          const <ArticlesTV1ArticalsGroupsL1DetailSummaryShort>[],
      this.status = ArticlesSummaryStatusStatus.initial});

  ArticleSummaryShortState copyWith({
    List<ArticlesTV1ArticalsGroupsL1DetailSummaryShort>?
        articlesTV1ArticalsGroupsL1DetailSummaryShort,
    bool? hasReachedMax,
    ArticlesSummaryStatusStatus? status,
  }) {
    return ArticleSummaryShortState(
      articlesTV1ArticalsGroupsL1DetailSummaryShort:
          articlesTV1ArticalsGroupsL1DetailSummaryShort ??
              this.articlesTV1ArticalsGroupsL1DetailSummaryShort,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [articlesTV1ArticalsGroupsL1DetailSummaryShort, status];
}
