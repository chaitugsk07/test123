part of 'tree_tags_bloc.dart';

@immutable
abstract class TreeTagsEvent extends Equatable {
  const TreeTagsEvent();
  @override
  List<Object?> get props => [];
}

class TreeTagsFetch extends TreeTagsEvent {
  final int tagHierarchyId;

  const TreeTagsFetch({required this.tagHierarchyId});
}
