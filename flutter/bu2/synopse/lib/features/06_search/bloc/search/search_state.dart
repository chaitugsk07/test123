part of 'search_bloc.dart';

class SearchState extends Equatable {
  final int searchId;
  final bool hasReachedMax;
  final SearchStatus status;

  const SearchState(
      {this.searchId = 0,
      this.hasReachedMax = false,
      this.status = SearchStatus.initial});

  SearchState copyWith({
    int? searchId,
    bool? hasReachedMax,
    SearchStatus? status,
  }) {
    return SearchState(
      searchId: searchId ?? this.searchId,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [searchId, hasReachedMax, status];
}
