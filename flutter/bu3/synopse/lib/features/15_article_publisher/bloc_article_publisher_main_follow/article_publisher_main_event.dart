part of 'article_publisher_main_bloc.dart';

@immutable
abstract class ArticlePublisherMainEvent extends Equatable {
  const ArticlePublisherMainEvent();
  @override
  List<Object?> get props => [];
}

class ArticlePublisherMainFetch extends ArticlePublisherMainEvent {
  final String logoUrl;

  const ArticlePublisherMainFetch({required this.logoUrl});
}
