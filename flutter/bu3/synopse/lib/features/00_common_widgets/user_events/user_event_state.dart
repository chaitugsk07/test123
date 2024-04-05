part of 'user_event_bloc.dart';

class UserEventState extends Equatable {
  final UserEventStatus status;

  const UserEventState({this.status = UserEventStatus.initial});

  UserEventState copyWith({
    UserEventStatus? status,
  }) {
    return UserEventState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
