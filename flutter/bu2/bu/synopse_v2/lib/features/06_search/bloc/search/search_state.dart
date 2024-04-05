part of 'search_bloc.dart';

class SearchState extends Equatable {
  final List<SynopseRealtimeGetEmbedding> synopseRealtimeGetEmbedding;
  final bool hasReachedMax;
  final SearchStatus status;

  const SearchState(
      {this.synopseRealtimeGetEmbedding = const <SynopseRealtimeGetEmbedding>[],
      this.hasReachedMax = false,
      this.status = SearchStatus.initial});

  SearchState copyWith({
    List<SynopseRealtimeGetEmbedding>? synopseRealtimeGetEmbedding,
    bool? hasReachedMax,
    SearchStatus? status,
  }) {
    return SearchState(
      synopseRealtimeGetEmbedding:
          synopseRealtimeGetEmbedding ?? this.synopseRealtimeGetEmbedding,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeGetEmbedding, hasReachedMax, status];
}
