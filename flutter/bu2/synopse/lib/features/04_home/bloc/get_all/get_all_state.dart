part of 'get_all_bloc.dart';

class GetAllState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2Detail>
      synopseArticlesTV4ArticleGroupsL2Detail;
  final bool hasReachedMax;
  final GetAllStatus status;

  const GetAllState(
      {this.synopseArticlesTV4ArticleGroupsL2Detail =
          const <SynopseArticlesTV4ArticleGroupsL2Detail>[],
      this.hasReachedMax = false,
      this.status = GetAllStatus.initial});

  GetAllState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2Detail>?
        synopseArticlesTV4ArticleGroupsL2Detail,
    bool? hasReachedMax,
    GetAllStatus? status,
  }) {
    return GetAllState(
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
