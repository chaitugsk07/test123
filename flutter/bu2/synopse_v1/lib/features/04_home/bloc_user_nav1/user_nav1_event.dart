part of 'user_nav1_bloc.dart';

@immutable
abstract class UserNav1Event extends Equatable {
  const UserNav1Event();
  @override
  List<Object?> get props => [];
}

class UserNav1Fetch extends UserNav1Event {}
