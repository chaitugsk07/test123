part of 'root_tags_bloc.dart';

@immutable
abstract class RootTagsEvent extends Equatable {
  const RootTagsEvent();
  @override
  List<Object?> get props => [];
}

class RootTagsFetch extends RootTagsEvent {}
