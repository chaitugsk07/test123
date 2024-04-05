part of 'get_all_liked_bloc.dart';

class GetAllLikedState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2Detail>
      synopseArticlesTV4ArticleGroupsL2Detail;
  final bool hasReachedMax;
  final GetAllLikedStatus status;

  const GetAllLikedState(
      {this.synopseArticlesTV4ArticleGroupsL2Detail =
          const <SynopseArticlesTV4ArticleGroupsL2Detail>[],
      this.hasReachedMax = false,
      this.status = GetAllLikedStatus.initial});

  GetAllLikedState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2Detail>?
        synopseArticlesTV4ArticleGroupsL2Detail,
    bool? hasReachedMax,
    GetAllLikedStatus? status,
  }) {
    return GetAllLikedState(
      synopseArticlesTV4ArticleGroupsL2Detail:
          synopseArticlesTV4ArticleGroupsL2Detail ??
              this.synopseArticlesTV4ArticleGroupsL2Detail,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesTV4ArticleGroupsL2Detail, hasReachedMax, status];
}
