part of 'articles_rss1_page_bloc.dart';

@immutable
abstract class ArticlesRss1PageEvent extends Equatable {
  const ArticlesRss1PageEvent();
  @override
  List<Object?> get props => [];
}

class ArticlesRss1PageFetch extends ArticlesRss1PageEvent {
  const ArticlesRss1PageFetch();
}
