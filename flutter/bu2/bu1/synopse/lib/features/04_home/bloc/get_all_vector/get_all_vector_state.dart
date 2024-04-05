part of 'get_all_vector_bloc.dart';

class GetAllVectorState extends Equatable {
  final List<SynopseArticlesFGetSearchArticleGroup>
      synopseArticlesFGetSearchArticleGroup;
  final bool hasReachedMax;
  final GetAllVectorStatus status;

  const GetAllVectorState(
      {this.synopseArticlesFGetSearchArticleGroup =
          const <SynopseArticlesFGetSearchArticleGroup>[],
      this.hasReachedMax = false,
      this.status = GetAllVectorStatus.initial});

  GetAllVectorState copyWith({
    List<SynopseArticlesFGetSearchArticleGroup>?
        synopseArticlesFGetSearchArticleGroup,
    bool? hasReachedMax,
    GetAllVectorStatus? status,
  }) {
    return GetAllVectorState(
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
