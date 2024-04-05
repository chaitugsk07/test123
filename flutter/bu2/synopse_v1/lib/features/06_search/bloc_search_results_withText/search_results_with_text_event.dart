part of 'search_results_with_text_bloc.dart';

@immutable
abstract class SearchResultsWithTextEvent extends Equatable {
  const SearchResultsWithTextEvent();
  @override
  List<Object?> get props => [];
}

class SearchResultsWithTextFetch extends SearchResultsWithTextEvent {
  final String search;

  const SearchResultsWithTextFetch({required this.search});
}

class SearchResultsWithTextRefresh extends SearchResultsWithTextEvent {
  final String search;

  const SearchResultsWithTextRefresh({required this.search});
}
