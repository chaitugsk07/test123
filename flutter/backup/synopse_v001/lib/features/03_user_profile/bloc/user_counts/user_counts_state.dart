part of 'user_counts_bloc.dart';

class UserCountsState extends Equatable {
  final UserCountsStatus status;
  final List<UserCounts> userCounts;

  const UserCountsState(
      {this.userCounts = const <UserCounts>[],
      this.status = UserCountsStatus.initial});

  UserCountsState copyWith({
    List<UserCounts>? userCounts,
    UserCountsStatus? status,
  }) {
    return UserCountsState(
      userCounts: userCounts ?? this.userCounts,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [userCounts, status];
}
