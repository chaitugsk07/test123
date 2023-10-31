part of 'article_comments_bloc.dart';

@immutable
abstract class ArticleCommentsEvent extends Equatable {
  const ArticleCommentsEvent();
  @override
  List<Object?> get props => [];
}

class ArticleCommentsFetch extends ArticleCommentsEvent {
  final int articleId;

  const ArticleCommentsFetch({required this.articleId});
}

class ArticleCommentsRefresh extends ArticleCommentsEvent {
  const ArticleCommentsRefresh();
}

class ArticleCommentsSend extends ArticleCommentsEvent {
  const ArticleCommentsSend();
}
