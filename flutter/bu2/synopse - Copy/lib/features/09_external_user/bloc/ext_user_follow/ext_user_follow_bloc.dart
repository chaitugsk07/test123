import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/source_syn_api.dart';

part 'ext_user_follow_event.dart';
part 'ext_user_follow_state.dart';

class ExtUserFollowBloc extends Bloc<ExtUserFollowEvent, ExtUserFollowState> {
  final RssFeedServicesFeed _rssFeedServices;

  ExtUserFollowBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ExtUserFollowState()) {
    // Initial Event
    on<ExtUserFollowFetch>(
      _onExtUserFollowFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onExtUserFollowFetch(
      ExtUserFollowFetch event, Emitter<ExtUserFollowState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getUserExtFollow(event.account);

    return emit(
      state.copyWith(
        followingCount: articles,
        hasReachedMax: false,
        status: ExtUserFollowStatus.success,
      ),
    );
  }
}

enum ExtUserFollowStatus {
  initial,
  success,
  error,
}
