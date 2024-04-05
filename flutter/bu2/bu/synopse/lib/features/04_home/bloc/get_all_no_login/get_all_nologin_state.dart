part of 'get_all_nologin_bloc.dart';

class GetAllNoLoginState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2DetailNoLogin>
      synopseArticlesTV4ArticleGroupsL2Detail;
  final bool hasReachedMax;
  final GetAllNoLoginStatus status;

  const GetAllNoLoginState(
      {this.synopseArticlesTV4ArticleGroupsL2Detail =
          const <SynopseArticlesTV4ArticleGroupsL2DetailNoLogin>[],
      this.hasReachedMax = false,
      this.status = GetAllNoLoginStatus.initial});

  GetAllNoLoginState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2DetailNoLogin>?
        synopseArticlesTV4ArticleGroupsL2Detail,
    bool? hasReachedMax,
    GetAllNoLoginStatus? status,
  }) {
    return GetAllNoLoginState(
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
