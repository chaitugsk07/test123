part of 'article_details_no_bloc.dart';

@immutable
abstract class ArticleDetailsNoEvent extends Equatable {
  const ArticleDetailsNoEvent();
  @override
  List<Object?> get props => [];
}

class ArticleDetailsNoFetch extends ArticleDetailsNoEvent {
  final int articleGrouppId;

  const ArticleDetailsNoFetch({required this.articleGrouppId});
}
