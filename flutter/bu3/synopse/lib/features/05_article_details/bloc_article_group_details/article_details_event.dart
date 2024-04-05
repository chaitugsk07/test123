part of 'article_details_bloc.dart';

@immutable
abstract class ArticleDetailsEvent extends Equatable {
  const ArticleDetailsEvent();
  @override
  List<Object?> get props => [];
}

class ArticleDetailsFetch extends ArticleDetailsEvent {
  final int articleGrouppId;

  const ArticleDetailsFetch({required this.articleGrouppId});
}
