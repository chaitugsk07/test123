part of 'article_detail_bloc.dart';

@immutable
abstract class ArticlesRss1DetailEvent extends Equatable {
  const ArticlesRss1DetailEvent();
  @override
  List<Object?> get props => [];
}

class ArticlesRss1DetailFetch extends ArticlesRss1DetailEvent {
  final String postLink1;
  const ArticlesRss1DetailFetch(this.postLink1);
}
