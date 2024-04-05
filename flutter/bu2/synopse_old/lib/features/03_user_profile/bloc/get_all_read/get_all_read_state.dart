part of 'get_all_read_bloc.dart';

class GetAllReadState extends Equatable {
  final List<SynopseArticlesTV4ArticleGroupsL2Detail>
      synopseArticlesTV4ArticleGroupsL2Detail;
  final bool hasReachedMax;
  final GetAllReadStatus status;

  const GetAllReadState(
      {this.synopseArticlesTV4ArticleGroupsL2Detail =
          const <SynopseArticlesTV4ArticleGroupsL2Detail>[],
      this.hasReachedMax = false,
      this.status = GetAllReadStatus.initial});

  GetAllReadState copyWith({
    List<SynopseArticlesTV4ArticleGroupsL2Detail>?
        synopseArticlesTV4ArticleGroupsL2Detail,
    bool? hasReachedMax,
    GetAllReadStatus? status,
  }) {
    return GetAllReadState(
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
