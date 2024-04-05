part of 'search_last3_with_text_bloc.dart';

class SearchLast3WithTextState extends Equatable {
  final List<SynopseRealtimeTTempUserSearchWithText>
      synopseRealtimeTTempUserSearchWithText;
  final bool hasReachedMax;
  final SearchLast3WithTextsStatus status;

  const SearchLast3WithTextState(
      {this.synopseRealtimeTTempUserSearchWithText =
          const <SynopseRealtimeTTempUserSearchWithText>[],
      this.hasReachedMax = false,
      this.status = SearchLast3WithTextsStatus.initial});

  SearchLast3WithTextState copyWith({
    List<SynopseRealtimeTTempUserSearchWithText>?
        synopseRealtimeTTempUserSearchWithText,
    bool? hasReachedMax,
    SearchLast3WithTextsStatus? status,
  }) {
    return SearchLast3WithTextState(
      synopseRealtimeTTempUserSearchWithText:
          synopseRealtimeTTempUserSearchWithText ??
              this.synopseRealtimeTTempUserSearchWithText,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeTTempUserSearchWithText, hasReachedMax, status];
}
