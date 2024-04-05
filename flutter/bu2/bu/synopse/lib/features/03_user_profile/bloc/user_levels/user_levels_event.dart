part of 'user_levels_bloc.dart';

@immutable
abstract class UserLevelsEvent extends Equatable {
  const UserLevelsEvent();
  @override
  List<Object?> get props => [];
}

class UserLevelsFetch extends UserLevelsEvent {
  const UserLevelsFetch();
}
