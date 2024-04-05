part of 'tags_hierarchy_bloc.dart';

class TagsHierarchyState extends Equatable {
  final List<SynopseArticlesTV4TagsHierarchyRoot>
      synopseArticlesTV4TagsHierarchyRoot;
  final bool hasReachedMax;
  final TagsHierarchyStatus status;

  const TagsHierarchyState(
      {this.synopseArticlesTV4TagsHierarchyRoot =
          const <SynopseArticlesTV4TagsHierarchyRoot>[],
      this.hasReachedMax = false,
      this.status = TagsHierarchyStatus.initial});

  TagsHierarchyState copyWith({
    List<SynopseArticlesTV4TagsHierarchyRoot>?
        synopseArticlesTV4TagsHierarchyRoot,
    bool? hasReachedMax,
    TagsHierarchyStatus? status,
  }) {
    return TagsHierarchyState(
      synopseArticlesTV4TagsHierarchyRoot:
          synopseArticlesTV4TagsHierarchyRoot ??
              this.synopseArticlesTV4TagsHierarchyRoot,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesTV4TagsHierarchyRoot, hasReachedMax, status];
}
