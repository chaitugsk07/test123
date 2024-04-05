part of 'search_results_bloc.dart';

class SearchResultsState extends Equatable {
  final List<SynopseArticlesFGetSearchArticleGroup>
      synopseArticlesFGetSearchArticleGroup;
  final bool hasReachedMax;
  final SearchResultsStatus status;

  const SearchResultsState(
      {this.synopseArticlesFGetSearchArticleGroup =
          const <SynopseArticlesFGetSearchArticleGroup>[],
      this.hasReachedMax = false,
      this.status = SearchResultsStatus.initial});

  SearchResultsState copyWith({
    List<SynopseArticlesFGetSearchArticleGroup>?
        synopseArticlesFGetSearchArticleGroup,
    bool? hasReachedMax,
    SearchResultsStatus? status,
  }) {
    return SearchResultsState(
      synopseArticlesFGetSearchArticleGroup:
          synopseArticlesFGetSearchArticleGroup ??
              this.synopseArticlesFGetSearchArticleGroup,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesFGetSearchArticleGroup, hasReachedMax, status];
}
