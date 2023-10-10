part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  final UserProfileStatus status;

  const UserProfileState({this.status = UserProfileStatus.initial});

  UserProfileState copyWith({
    UserProfileStatus? status,
  }) {
    return UserProfileState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
