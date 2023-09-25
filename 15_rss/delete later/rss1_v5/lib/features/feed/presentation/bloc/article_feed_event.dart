part of 'article_feed_bloc.dart';

abstract class ArticleFeedEvent extends Equatable {
  const ArticleFeedEvent();

  @override
  List<Object> get props => [];
}

class LoadArticleFeed extends ArticleFeedEvent {}

class FilterArticleFeed extends ArticleFeedEvent {
  final String nameFilter;

  const FilterArticleFeed({required this.nameFilter});

  @override
  List<Object> get props => [nameFilter];
}
