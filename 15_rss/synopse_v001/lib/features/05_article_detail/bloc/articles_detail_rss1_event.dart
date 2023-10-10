part of 'articles_detail_rss1_bloc.dart';

@immutable
abstract class ArticleDetailEvent extends Equatable {
  const ArticleDetailEvent();
  @override
  List<Object?> get props => [];
}

class ArticlesDetailFetch extends ArticleDetailEvent {
  final int articleGroupId;

  const ArticlesDetailFetch({
    required this.articleGroupId,
  });

  @override
  List<Object> get props => [articleGroupId];
}
