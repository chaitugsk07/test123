import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_comments.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'comments1_reply_event.dart';
part 'comments1_reply_state.dart';

class Comments1RBloc extends Bloc<Comments1REvent, Comments1RState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  Comments1RBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const Comments1RState()) {
    // Initial Event
    on<Comments1RFetch>(
      _onComments1RFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<Comments1RRefresh>(
      _onComments1RRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onComments1RFetch(
      Comments1RFetch event, Emitter<Comments1RState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == Comments1RStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getArticleSCommentsReply(
          20, 0, event.commentId);
      return emit(
        state.copyWith(
          synopseRealtimeVUserArticleComment: articles,
          hasReachedMax: false,
          status: Comments1RStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getArticleSCommentsReply(
        10, 10 + 10 * _currentPage, event.commentId);
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

  FutureOr<void> _onComments1RRefresh(
      Comments1RRefresh event, Emitter<Comments1RState> emit) async {
    emit(const Comments1RState());
    await Future.delayed(const Duration(seconds: 1));
    add(
      Comments1RFetch(commentId: event.commentId),
    );
  }
}

enum Comments1RStatus {
  initial,
  success,
  error,
}
