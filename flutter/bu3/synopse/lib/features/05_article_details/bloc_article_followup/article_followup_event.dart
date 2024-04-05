part of 'article_followup_bloc.dart';

@immutable
abstract class ArticleFollowupEvent extends Equatable {
  const ArticleFollowupEvent();
  @override
  List<Object?> get props => [];
}

class ArticleFollowupFetch extends ArticleFollowupEvent {
  final int articleFollowup;

  const ArticleFollowupFetch({required this.articleFollowup});
}
