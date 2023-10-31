part of 'articles_rss1_bloc.dart';

@immutable
abstract class ArticlesRss1Event extends Equatable {
  const ArticlesRss1Event();
  @override
  List<Object?> get props => [];
}

class ArticlesRss1Fetch extends ArticlesRss1Event {
  const ArticlesRss1Fetch();
}

class ArticlesRss1Refresh extends ArticlesRss1Event {
  const ArticlesRss1Refresh();
}
