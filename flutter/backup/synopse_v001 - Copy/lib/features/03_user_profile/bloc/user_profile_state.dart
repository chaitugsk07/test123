part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  final UserProfileStatus status;
  final List<AuthAuth1User> authAuth1User;

  const UserProfileState(
      {this.authAuth1User = const <AuthAuth1User>[],
      this.status = UserProfileStatus.initial});

  UserProfileState copyWith({
    List<AuthAuth1User>? authAuth1User,
    UserProfileStatus? status,
  }) {
    return UserProfileState(
      authAuth1User: authAuth1User ?? this.authAuth1User,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [authAuth1User, status];
}
