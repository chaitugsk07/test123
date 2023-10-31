part of 'articlesgroup_rss1_bloc.dart';

class ArticlesGroupRss1State extends Equatable {
  final List<ArticlesTV1ArticalsGroupsL1Detail> articlesTV1ArticalsGroupsL1Detail;
  final bool hasReachedMax;
  final ArticlesGroupRss1Status status;

  const ArticlesGroupRss1State(
      {this.articlesTV1ArticalsGroupsL1Detail = const <ArticlesTV1ArticalsGroupsL1Detail>[],
      this.hasReachedMax = false,
      this.status = ArticlesGroupRss1Status.initial});

  ArticlesGroupRss1State copyWith({
    List<ArticlesTV1ArticalsGroupsL1Detail>? articlesTV1ArticalsGroupsL1Detail,
    bool? hasReachedMax,
    ArticlesGroupRss1Status? status,
  }) {
    return ArticlesGroupRss1State(
      articlesTV1ArticalsGroupsL1Detail: articlesTV1ArticalsGroupsL1Detail ?? this.articlesTV1ArticalsGroupsL1Detail,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesTV1ArticalsGroupsL1Detail, hasReachedMax, status];
}
