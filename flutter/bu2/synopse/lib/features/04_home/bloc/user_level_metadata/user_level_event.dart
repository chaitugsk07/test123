part of 'user_level_bloc.dart';

@immutable
abstract class UserLevelEvent extends Equatable {
  const UserLevelEvent();
  @override
  List<Object?> get props => [];
}

class UserLevelFetch extends UserLevelEvent {
  final String account;

  const UserLevelFetch({required this.account});
}
