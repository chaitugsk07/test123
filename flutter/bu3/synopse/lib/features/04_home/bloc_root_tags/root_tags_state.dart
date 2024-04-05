part of 'root_tags_bloc.dart';

class RootTagsState extends Equatable {
  final List<SynopseArticlesTV4TagsHierarchyRootForYou>
      synopseArticlesTV4TagsHierarchyRootForYou;
  final bool hasReachedMax;
  final RootTagsStatus status;

  const RootTagsState(
      {this.synopseArticlesTV4TagsHierarchyRootForYou =
          const <SynopseArticlesTV4TagsHierarchyRootForYou>[],
      this.hasReachedMax = false,
      this.status = RootTagsStatus.initial});

  RootTagsState copyWith({
    List<SynopseArticlesTV4TagsHierarchyRootForYou>?
        synopseArticlesTV4TagsHierarchyRootForYou,
    bool? hasReachedMax,
    RootTagsStatus? status,
  }) {
    return RootTagsState(
      synopseArticlesTV4TagsHierarchyRootForYou:
          synopseArticlesTV4TagsHierarchyRootForYou ??
              this.synopseArticlesTV4TagsHierarchyRootForYou,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesTV4TagsHierarchyRootForYou, hasReachedMax, status];
}
