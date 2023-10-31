part of 'article_summary_bloc.dart';

@immutable
abstract class ArticleSummaryShortEvent extends Equatable {
  const ArticleSummaryShortEvent();
  @override
  List<Object?> get props => [];
}

class ArticleSummaryShortFetch extends ArticleSummaryShortEvent {
  final int articleId;

  const ArticleSummaryShortFetch({required this.articleId});
}
