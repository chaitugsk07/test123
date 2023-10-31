part of 'articles_original_bloc.dart';

@immutable
abstract class ArticlesOriginalEvent extends Equatable {
  const ArticlesOriginalEvent();
  @override
  List<Object?> get props => [];
}

class ArticlesOriginalFetch extends ArticlesOriginalEvent {
  final List articleIds;
  const ArticlesOriginalFetch({
    required this.articleIds,
  });

  @override
  List<Object> get props => [articleIds];
}

class ArticlesOriginalRefresh extends ArticlesOriginalEvent {
  const ArticlesOriginalRefresh();
}
