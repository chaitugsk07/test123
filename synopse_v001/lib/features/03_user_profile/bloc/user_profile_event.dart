part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object?> get props => [];
}

class UserProfileSet extends UserProfileEvent {
  final bool userName;
  final String userNameData;
  final bool bio;
  final String bioData;
  final bool userPhoto;
  final int userPhotoData;

  const UserProfileSet(
      {required this.userName,
      required this.userNameData,
      required this.bio,
      required this.bioData,
      required this.userPhoto,
      required this.userPhotoData});

  @override
  List<Object> get props =>
      [userName, userNameData, bio, bioData, userPhoto, userPhotoData];
}

class UserProfileGet extends UserProfileEvent {
  const UserProfileGet();
}
