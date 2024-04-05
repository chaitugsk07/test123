part of 'get_all_publisher_bloc.dart';

class GetAllPublisherState extends Equatable {
  final List<SynopseArticlesTV1Rss1ArticleF1> synopseArticlesTV1Rss1ArticleF1;
  final bool hasReachedMax;
  final GetAllPublisherStatus status;

  const GetAllPublisherState(
      {this.synopseArticlesTV1Rss1ArticleF1 =
          const <SynopseArticlesTV1Rss1ArticleF1>[],
      this.hasReachedMax = false,
      this.status = GetAllPublisherStatus.initial});

  GetAllPublisherState copyWith({
    List<SynopseArticlesTV1Rss1ArticleF1>? synopseArticlesTV1Rss1ArticleF1,
    bool? hasReachedMax,
    GetAllPublisherStatus? status,
  }) {
    return GetAllPublisherState(
      synopseArticlesTV1Rss1ArticleF1: synopseArticlesTV1Rss1ArticleF1 ??
          this.synopseArticlesTV1Rss1ArticleF1,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesTV1Rss1ArticleF1, hasReachedMax, status];
}
