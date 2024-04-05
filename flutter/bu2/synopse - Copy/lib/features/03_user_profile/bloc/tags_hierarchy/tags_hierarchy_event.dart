part of 'tags_hierarchy_bloc.dart';

@immutable
abstract class TagsHierarchyEvent extends Equatable {
  const TagsHierarchyEvent();
  @override
  List<Object?> get props => [];
}

class TagsHierarchyFetch extends TagsHierarchyEvent {
  const TagsHierarchyFetch();
}
