part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object?> get props => [];
}

class UserProfileSet extends UserProfileEvent {
  final String userProfile;
  final String bio;
  const UserProfileSet({
    required this.userProfile,
    required this.bio,
  });

  @override
  List<Object> get props => [userProfile, bio];
}
