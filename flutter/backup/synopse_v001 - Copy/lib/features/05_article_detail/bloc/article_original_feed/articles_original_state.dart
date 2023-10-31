part of 'articles_original_bloc.dart';

class ArticlesOriginalState extends Equatable {
  final List<ArticlesTV1Rss1Artical> articlesTV1Rss1Artical;
  final bool hasReachedMax;
  final ArticlesOriginalStatus status;

  const ArticlesOriginalState(
      {this.articlesTV1Rss1Artical = const <ArticlesTV1Rss1Artical>[],
      this.hasReachedMax = false,
      this.status = ArticlesOriginalStatus.initial});

  ArticlesOriginalState copyWith({
    List<ArticlesTV1Rss1Artical>? articlesTV1Rss1Artical,
    bool? hasReachedMax,
    ArticlesOriginalStatus? status,
  }) {
    return ArticlesOriginalState(
      articlesTV1Rss1Artical:
          articlesTV1Rss1Artical ?? this.articlesTV1Rss1Artical,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [articlesTV1Rss1Artical, hasReachedMax, status];
}
