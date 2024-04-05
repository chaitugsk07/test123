import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_comments.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'comments1_r_event.dart';
part 'comments1_r_state.dart';

class Comments1R1Bloc extends Bloc<Comments1R1Event, Comments1R1State> {
  final RssFeedServicesFeed _rssFeedServices;

  Comments1R1Bloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const Comments1R1State()) {
    // Initial Event
    on<Comments1R1Fetch>(
      _onComments1R1Fetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onComments1R1Fetch(
      Comments1R1Fetch event, Emitter<Comments1R1State> emit) async {
    if (state.hasReachedMax) return;
    final articles = await _rssFeedServices.getArticleComment(event.commnentId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeVUserArticleComment:
              List.of(state.synopseRealtimeVUserArticleComment)
                ..addAll(articles),
          hasReachedMax: false,
          status: Comments1R1Status.success,
        ),
      );
    }
  }
}

enum Comments1R1Status {
  initial,
  success,
  error,
}
