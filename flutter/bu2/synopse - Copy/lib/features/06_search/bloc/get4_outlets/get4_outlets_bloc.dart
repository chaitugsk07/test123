import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_get4_outlets.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get4_outlets_event.dart';
part 'get4_outlets_state.dart';

class Get4OutletsBloc extends Bloc<Get4OutletsEvent, Get4OutletsState> {
  final RssFeedServicesFeed _rssFeedServices;

  Get4OutletsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const Get4OutletsState()) {
    // Initial Event
    on<Get4OutletsFetch>(
      _onGet4OutletsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGet4OutletsFetch(
      Get4OutletsFetch event, Emitter<Get4OutletsState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.get4Outlets();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesVGet4Outlet: List.of(state.synopseArticlesVGet4Outlet)
            ..addAll(articles),
          hasReachedMax: false,
          status: Get4OutletssStatus.success,
        ),
      );
    }
  }
}

enum Get4OutletssStatus {
  initial,
  success,
  error,
}
