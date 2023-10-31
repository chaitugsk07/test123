import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/03_user_profile/01_models_repo/mod_user_counts.dart';
import 'package:synopse_v001/features/03_user_profile/01_models_repo/source_user_profile_api.dart';

part 'user_counts_event.dart';
part 'user_counts_state.dart';

class UserCountsBloc extends Bloc<UserCountsEvent, UserCountsState> {
  final UserProfileService _userProfileService;

  UserCountsBloc({required UserProfileService userProfileService})
      : _userProfileService = userProfileService,
        super(const UserCountsState()) {
    // Initial Event
    on<UserCountGet>(
      _onGetUserCounts,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetUserCounts(
      UserCountGet event, Emitter<UserCountsState> emit) async {
    final user = await _userProfileService.getUserCountProfile(event.userId);
    emit(state.copyWith(
      status: UserCountsStatus.success,
      userCounts: user,
    ));
  }
}

enum UserCountsStatus {
  initial,
  success,
  error,
}
