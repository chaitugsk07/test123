import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_user_intrests.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_intrests_event.dart';
part 'user_intrests_state.dart';

class UserIntrestsTagsBloc
    extends Bloc<UserIntrestsTagsEvent, UserIntrestsTagsState> {
  final RssFeedServicesFeed _rssFeedServices;

  UserIntrestsTagsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserIntrestsTagsState()) {
    // Initial Event
    on<UserIntrestsTagsFetch>(
      _onUserIntrestsTagsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserIntrestsTagsFetch(
      UserIntrestsTagsFetch event, Emitter<UserIntrestsTagsState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getUserIntrestTags();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeTUserTag: List.of(state.synopseRealtimeTUserTag)
            ..addAll(articles),
          hasReachedMax: false,
          status: UserIntrestsTagsStatus.success,
        ),
      );
    }
  }
}

enum UserIntrestsTagsStatus {
  initial,
  success,
  error,
}
