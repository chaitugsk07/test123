part of 'search_last3_bloc.dart';

class SearchLast3State extends Equatable {
  final List<SynopseRealtimeTTempUserSearch> synopseRealtimeTTempUserSearch;
  final bool hasReachedMax;
  final SearchLast3sStatus status;

  const SearchLast3State(
      {this.synopseRealtimeTTempUserSearch =
          const <SynopseRealtimeTTempUserSearch>[],
      this.hasReachedMax = false,
      this.status = SearchLast3sStatus.initial});

  SearchLast3State copyWith({
    List<SynopseRealtimeTTempUserSearch>? synopseRealtimeTTempUserSearch,
    bool? hasReachedMax,
    SearchLast3sStatus? status,
  }) {
    return SearchLast3State(
      synopseRealtimeTTempUserSearch:
          synopseRealtimeTTempUserSearch ?? this.synopseRealtimeTTempUserSearch,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeTTempUserSearch, hasReachedMax, status];
}
