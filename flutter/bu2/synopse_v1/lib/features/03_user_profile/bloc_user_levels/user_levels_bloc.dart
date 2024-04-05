import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_level_info.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_levels_event.dart';
part 'user_levels_state.dart';

class UserLevelsBloc extends Bloc<UserLevelsEvent, UserLevelsState> {
  final RssFeedServicesFeed _rssFeedServices;

  UserLevelsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserLevelsState()) {
    // Initial Event
    on<UserLevelsFetch>(
      _onUserLevelsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserLevelsFetch(
      UserLevelsFetch event, Emitter<UserLevelsState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getUserLevels();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeTUserLevel: List.of(state.synopseRealtimeTUserLevel)
            ..addAll(articles),
          hasReachedMax: false,
          status: UserLevelsStatus.success,
        ),
      );
    }
  }
}

enum UserLevelsStatus {
  initial,
  success,
  error,
}
