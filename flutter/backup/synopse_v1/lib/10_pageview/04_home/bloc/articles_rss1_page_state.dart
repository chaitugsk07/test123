part of 'articles_rss1_page_bloc.dart';

class ArticlesRss1PageState extends Equatable {
  final List<ArticlesTV1ArticalsGroupsL1DetailPage>
      articlesTV1ArticalsGroupsL1DetailPage;
  final bool hasReachedMax;
  final ArticlesRss1PageStatus status;

  const ArticlesRss1PageState(
      {this.articlesTV1ArticalsGroupsL1DetailPage =
          const <ArticlesTV1ArticalsGroupsL1DetailPage>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1PageStatus.initial});

  ArticlesRss1PageState copyWith({
    List<ArticlesTV1ArticalsGroupsL1DetailPage>?
        articlesTV1ArticalsGroupsL1DetailPage,
    bool? hasReachedMax,
    ArticlesRss1PageStatus? status,
  }) {
    return ArticlesRss1PageState(
      articlesTV1ArticalsGroupsL1DetailPage:
          articlesTV1ArticalsGroupsL1DetailPage ??
              this.articlesTV1ArticalsGroupsL1DetailPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [articlesTV1ArticalsGroupsL1DetailPage, hasReachedMax, status];
}
