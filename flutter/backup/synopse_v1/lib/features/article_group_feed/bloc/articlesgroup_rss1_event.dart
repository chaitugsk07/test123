part of 'articlesgroup_rss1_bloc.dart';

@immutable
abstract class ArticlesGroupRss1Event extends Equatable {
  const ArticlesGroupRss1Event();
  @override
  List<Object?> get props => [];
}

class ArticlesGroupRss1Fetch extends ArticlesGroupRss1Event {
  const ArticlesGroupRss1Fetch();
}

class ArticlesGroupRss1Refresh extends ArticlesGroupRss1Event {
  const ArticlesGroupRss1Refresh();
}
