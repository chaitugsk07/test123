part of 'tree_tags_bloc.dart';

class TreeTagsState extends Equatable {
  final List<SynopseArticlesTV4TagsHierarchyTree>
      synopseArticlesTV4TagsHierarchyTree;
  final bool hasReachedMax;
  final TreeTagsStatus status;

  const TreeTagsState(
      {this.synopseArticlesTV4TagsHierarchyTree =
          const <SynopseArticlesTV4TagsHierarchyTree>[],
      this.hasReachedMax = false,
      this.status = TreeTagsStatus.initial});

  TreeTagsState copyWith({
    List<SynopseArticlesTV4TagsHierarchyTree>?
        synopseArticlesTV4TagsHierarchyTree,
    bool? hasReachedMax,
    TreeTagsStatus? status,
  }) {
    return TreeTagsState(
      synopseArticlesTV4TagsHierarchyTree:
          synopseArticlesTV4TagsHierarchyTree ??
              this.synopseArticlesTV4TagsHierarchyTree,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesTV4TagsHierarchyTree, hasReachedMax, status];
}
