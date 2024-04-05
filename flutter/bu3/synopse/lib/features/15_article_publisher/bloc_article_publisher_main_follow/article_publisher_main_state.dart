part of 'article_publisher_main_bloc.dart';

class ArticlePublisherMainState extends Equatable {
  final List<SynopseArticlesTV1Outlet> synopseArticlesTV1Outlet;
  final bool hasReachedMax;
  final ArticlePublisherMainStatus status;

  const ArticlePublisherMainState(
      {this.synopseArticlesTV1Outlet = const <SynopseArticlesTV1Outlet>[],
      this.hasReachedMax = false,
      this.status = ArticlePublisherMainStatus.initial});

  ArticlePublisherMainState copyWith({
    List<SynopseArticlesTV1Outlet>? synopseArticlesTV1Outlet,
    bool? hasReachedMax,
    ArticlePublisherMainStatus? status,
  }) {
    return ArticlePublisherMainState(
      synopseArticlesTV1Outlet:
          synopseArticlesTV1Outlet ?? this.synopseArticlesTV1Outlet,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [synopseArticlesTV1Outlet, hasReachedMax, status];
}
