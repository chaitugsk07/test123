part of 'articles_rss1_bloc.dart';

class ArticlesRss1State extends Equatable {
  final List<Rss1Artical> rss1Articals;
  final bool hasReachedMax;
  final ArticlesRss1Status status;

  const ArticlesRss1State(
      {this.rss1Articals = const <Rss1Artical>[],
      this.hasReachedMax = false,
      this.status = ArticlesRss1Status.initial});

  ArticlesRss1State copyWith({
    List<Rss1Artical>? rss1Articals,
    bool? hasReachedMax,
    ArticlesRss1Status? status,
  }) {
    return ArticlesRss1State(
      rss1Articals: rss1Articals ?? this.rss1Articals,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [rss1Articals, hasReachedMax, status];
}
