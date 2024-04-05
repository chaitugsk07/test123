import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_user.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'ext_user_event.dart';
part 'ext_user_state.dart';

class ExtUserBloc extends Bloc<ExtUserEvent, ExtUserState> {
  final RssFeedServicesFeed _rssFeedServices;

  ExtUserBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ExtUserState()) {
    // Initial Event
    on<ExtUserFetch>(
      _onExtUserFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onExtUserFetch(
      ExtUserFetch event, Emitter<ExtUserState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getUserDetails(event.account);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeVUserMetadatum:
              List.of(state.synopseRealtimeVUserMetadatum)..addAll(articles),
          hasReachedMax: false,
          status: ExtUserStatus.success,
        ),
      );
    }
  }
}

enum ExtUserStatus {
  initial,
  success,
  error,
}
