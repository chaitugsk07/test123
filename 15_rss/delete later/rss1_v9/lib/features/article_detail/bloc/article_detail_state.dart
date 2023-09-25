part of 'article_detail_bloc.dart';

class ArticlesRss1DetailState extends Equatable {
  final List<Rss1ArticlesDetail> rss1ArticlesDetail;
  final ArticlesRss1DetailStatus status;

  const ArticlesRss1DetailState(
      {this.rss1ArticlesDetail = const <Rss1ArticlesDetail>[],
      this.status = ArticlesRss1DetailStatus.initial});

  ArticlesRss1DetailState copyWith({
    List<Rss1ArticlesDetail>? rss1ArticlesDetail,
    ArticlesRss1DetailStatus? status,
  }) {
    return ArticlesRss1DetailState(
      rss1ArticlesDetail: rss1ArticlesDetail ?? this.rss1ArticlesDetail,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [rss1ArticlesDetail, status];
}
