part of 'user_counts_bloc.dart';

@immutable
abstract class UserCountsEvent extends Equatable {
  const UserCountsEvent();
  @override
  List<Object?> get props => [];
}

class UserCountGet extends UserCountsEvent {
  final String userId;

  const UserCountGet({required this.userId});

  @override
  List<Object> get props => [userId];
}
