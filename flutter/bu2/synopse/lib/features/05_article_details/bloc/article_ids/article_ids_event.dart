part of 'article_ids_bloc.dart';

@immutable
abstract class ArticleIdsEvent extends Equatable {
  const ArticleIdsEvent();
  @override
  List<Object?> get props => [];
}

class ArticleIdsFetch extends ArticleIdsEvent {
  final List articleIds;

  const ArticleIdsFetch({required this.articleIds});
}
