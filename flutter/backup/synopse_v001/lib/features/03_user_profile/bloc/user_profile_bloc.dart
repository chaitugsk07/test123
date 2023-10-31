import 'dart:async';
import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/03_user_profile/01_models_repo/mod_user_profile.dart';
import 'package:synopse_v001/features/03_user_profile/01_models_repo/source_user_profile_api.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileService _userProfileService;

  UserProfileBloc({required UserProfileService userProfileService})
      : _userProfileService = userProfileService,
        super(const UserProfileState()) {
    // Initial Event
    on<UserProfileSet>(
      _onSetUserProfile,
      transformer: droppable(),
    );
    // Initial Event
    on<UserProfileGet>(
      _onGetUserProfile,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSetUserProfile(
      UserProfileSet event, Emitter<UserProfileState> emit) async {
    if (event.userName) {
      final articles =
          await _userProfileService.setUserProfileUserName(event.userNameData);
      log(articles.toLowerCase());
    }
    if (event.bio) {
      final articles =
          await _userProfileService.setUserProfileBio(event.bioData);
      log(articles.toLowerCase());
    }
    if (event.userPhoto) {
      final articles =
          await _userProfileService.setUserProfilePhoto(event.userPhotoData);
      log(articles.toLowerCase());
    }
  }

  FutureOr<void> _onGetUserProfile(
      UserProfileGet event, Emitter<UserProfileState> emit) async {
    final user = await _userProfileService.getUserProfile();
    return emit(
      state.copyWith(
          authAuth1User: List.of(state.authAuth1User)..addAll(user),
          status: UserProfileStatus.success),
    );
  }
}

enum UserProfileStatus {
  initial,
  success,
  error,
}
