import 'dart:async';
import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/06_user_profile/01_models_repo/source_user_profile_api.dart';

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
  }
  FutureOr<void> _onSetUserProfile(
      UserProfileSet event, Emitter<UserProfileState> emit) async {
    final articles =
        await _userProfileService.setUserProfile(event.userProfile, event.bio);
    log(articles.toLowerCase());
  }
}

enum UserProfileStatus {
  initial,
  success,
  error,
}
