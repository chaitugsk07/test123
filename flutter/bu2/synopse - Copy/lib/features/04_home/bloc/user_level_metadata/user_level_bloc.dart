import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_user_level.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_level_event.dart';
part 'user_level_state.dart';

class UserLevelBloc extends Bloc<UserLevelEvent, UserLevelState> {
  final RssFeedServicesFeed _rssFeedServices;

  UserLevelBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserLevelState()) {
    // Initial Event
    on<UserLevelFetch>(
      _onUserLevelFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserLevelFetch(
      UserLevelFetch event, Emitter<UserLevelState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getMyUserLevel(event.account);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeVUserLevel: List.of(state.synopseRealtimeVUserLevel)
            ..addAll(articles),
          hasReachedMax: false,
          status: UserLevelStatus.success,
        ),
      );
    }
  }
}

enum UserLevelStatus {
  initial,
  success,
  error,
}
