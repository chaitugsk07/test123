import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_comments.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'comments1_event.dart';
part 'comments1_state.dart';

class Comments1Bloc extends Bloc<Comments1Event, Comments1State> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  Comments1Bloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const Comments1State()) {
    // Initial Event
    on<Comments1Fetch>(
      _onComments1Fetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<Comments1Refresh>(
      _onComments1Refresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onComments1Fetch(
      Comments1Fetch event, Emitter<Comments1State> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == Comments1Status.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getArticleSComments(
          20, 0, event.articleGroupId);
      return emit(
        state.copyWith(
          synopseRealtimeVUserArticleComment: articles,
          hasReachedMax: false,
          status: Comments1Status.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getArticleSComments(
        10, 10 + 10 * _currentPage, event.articleGroupId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeVUserArticleComment:
              List.of(state.synopseRealtimeVUserArticleComment)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }

  FutureOr<void> _onComments1Refresh(
      Comments1Refresh event, Emitter<Comments1State> emit) async {
    emit(const Comments1State(status: Comments1Status.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(Comments1Fetch(articleGroupId: event.articleGroupId));
  }
}

enum Comments1Status {
  initial,
  success,
  error,
}
