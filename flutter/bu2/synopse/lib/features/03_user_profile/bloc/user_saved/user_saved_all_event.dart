part of 'user_saved_all_bloc.dart';

@immutable
abstract class UserSavedEvent extends Equatable {
  const UserSavedEvent();
  @override
  List<Object?> get props => [];
}

class UserSavedFetch extends UserSavedEvent {}
