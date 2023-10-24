part of 'articles_short_bloc.dart';

@immutable
abstract class ArticleShortEvent extends Equatable {
  const ArticleShortEvent();
  @override
  List<Object?> get props => [];
}

class ArticleShortFetch extends ArticleShortEvent {
  const ArticleShortFetch();
}

class ArticleShortRefresh extends ArticleShortEvent {
  const ArticleShortRefresh();
}
