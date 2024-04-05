part of 'user_nav1_bloc.dart';

class UserNav1State extends Equatable {
  final List<SynopseAuthTAuthUserProfile> synopseAuthTAuthUserProfile;
  final bool hasReachedMax;
  final UserNav1Status status;

  const UserNav1State(
      {this.synopseAuthTAuthUserProfile = const <SynopseAuthTAuthUserProfile>[],
      this.hasReachedMax = false,
      this.status = UserNav1Status.initial});

  UserNav1State copyWith({
    List<SynopseAuthTAuthUserProfile>? synopseAuthTAuthUserProfile,
    bool? hasReachedMax,
    UserNav1Status? status,
  }) {
    return UserNav1State(
      synopseAuthTAuthUserProfile:
          synopseAuthTAuthUserProfile ?? this.synopseAuthTAuthUserProfile,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseAuthTAuthUserProfile, hasReachedMax, status];
}
