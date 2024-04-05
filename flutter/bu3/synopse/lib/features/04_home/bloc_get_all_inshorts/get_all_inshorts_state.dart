part of 'get_all_inshorts_bloc.dart';

class GetAllInShortsState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2DetailInShorts>
      synopseArticlesTV4ArticleGroupsL2DetailInShorts;
  final bool hasReachedMax;
  final bool hasReachedMaxNa;
  final GetAllInShortsStatus status;

  const GetAllInShortsState(
      {this.synopseArticlesTV4ArticleGroupsL2DetailInShorts =
          const <SynopseArticlesTV4ArticleGroupsL2DetailInShorts>[],
      this.hasReachedMax = false,
      this.hasReachedMaxNa = false,
      this.status = GetAllInShortsStatus.initial});

  GetAllInShortsState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2DetailInShorts>?
        synopseArticlesTV4ArticleGroupsL2DetailInShorts,
    bool? hasReachedMax,
    bool? hasReachedMaxNa,
    GetAllInShortsStatus? status,
  }) {
    return GetAllInShortsState(
      synopseArticlesTV4ArticleGroupsL2DetailInShorts:
          synopseArticlesTV4ArticleGroupsL2DetailInShorts ??
              this.synopseArticlesTV4ArticleGroupsL2DetailInShorts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      hasReachedMaxNa: hasReachedMaxNa ?? this.hasReachedMaxNa,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        synopseArticlesTV4ArticleGroupsL2DetailInShorts,
        hasReachedMax,
        hasReachedMaxNa,
        status
      ];
}
