part of 'user_intrests_tags_bloc.dart';

@immutable
abstract class UserIntrestsTagsEvent extends Equatable {
  const UserIntrestsTagsEvent();
  @override
  List<Object?> get props => [];
}

class UserIntrestsTagsFetch extends UserIntrestsTagsEvent {}
