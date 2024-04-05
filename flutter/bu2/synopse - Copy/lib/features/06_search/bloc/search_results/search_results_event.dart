part of 'search_results_bloc.dart';

@immutable
abstract class SearchResultsEvent extends Equatable {
  const SearchResultsEvent();
  @override
  List<Object?> get props => [];
}

class SearchResultsFetch extends SearchResultsEvent {
  final int searchId;

  const SearchResultsFetch({required this.searchId});
}

class SearchResultsRefresh extends SearchResultsEvent {
  final int searchId;

  const SearchResultsRefresh({required this.searchId});
}
