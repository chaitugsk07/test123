part of 'article_feed_bloc.dart';

abstract class ArticleFeedState extends Equatable {
  const ArticleFeedState();

  @override
  List<Object> get props => [];
}

class ArticleFeedInitial extends ArticleFeedState {}

class ArticleFeedLoading extends ArticleFeedState {}

class ArticleFeedSuccess extends ArticleFeedState {
  final List<UiArticle> articals;

  const ArticleFeedSuccess({required this.articals});

  @override
  List<Object> get props => [articals];
}

class ArticleFeedFailure extends ArticleFeedState {
  final Exception exception;

  const ArticleFeedFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
