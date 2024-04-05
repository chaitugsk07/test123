part of 'search_results_with_text_bloc.dart';

class SearchResultsWithTextState extends Equatable {
  final List<SynopseArticlesVArticlesGroupDetailsSearch>
      synopseArticlesVArticlesGroupDetailsSearch;
  final bool hasReachedMax;
  final SearchResultsWithTextStatus status;

  const SearchResultsWithTextState(
      {this.synopseArticlesVArticlesGroupDetailsSearch =
          const <SynopseArticlesVArticlesGroupDetailsSearch>[],
      this.hasReachedMax = false,
      this.status = SearchResultsWithTextStatus.initial});

  SearchResultsWithTextState copyWith({
    List<SynopseArticlesVArticlesGroupDetailsSearch>?
        synopseArticlesVArticlesGroupDetailsSearch,
    bool? hasReachedMax,
    SearchResultsWithTextStatus? status,
  }) {
    return SearchResultsWithTextState(
      synopseArticlesVArticlesGroupDetailsSearch:
          synopseArticlesVArticlesGroupDetailsSearch ??
              this.synopseArticlesVArticlesGroupDetailsSearch,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesVArticlesGroupDetailsSearch, hasReachedMax, status];
}
