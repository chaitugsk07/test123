part of 'comments1_article_bloc.dart';

@immutable
abstract class Comments1ArticleEvent extends Equatable {
  const Comments1ArticleEvent();
  @override
  List<Object?> get props => [];
}

class Comments1ArticleFetch extends Comments1ArticleEvent {
  final int articleGroupId;

  const Comments1ArticleFetch({required this.articleGroupId});
}
