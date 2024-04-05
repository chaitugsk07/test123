import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_user_nav1.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_nav1_event.dart';
part 'user_nav1_state.dart';

class UserNav1Bloc extends Bloc<UserNav1Event, UserNav1State> {
  final RssFeedServicesFeed _rssFeedServices;

  UserNav1Bloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserNav1State()) {
    // Initial Event
    on<UserNav1Fetch>(
      _onUserNav1Fetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserNav1Fetch(
      UserNav1Fetch event, Emitter<UserNav1State> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getMyUserNav1();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseAuthTAuthUserProfile:
              List.of(state.synopseAuthTAuthUserProfile)..addAll(articles),
          hasReachedMax: false,
          status: UserNav1Status.success,
        ),
      );
    }
  }
}

enum UserNav1Status {
  initial,
  success,
  error,
}
