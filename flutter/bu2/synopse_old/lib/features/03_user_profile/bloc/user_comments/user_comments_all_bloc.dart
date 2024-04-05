import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_profile_comments.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_comments_all_event.dart';
part 'user_comments_all_state.dart';

class UserCommentsBloc extends Bloc<UserCommentsEvent, UserCommentsState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  UserCommentsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserCommentsState()) {
    // Initial Event
    on<UserCommentsFetch>(
      _onUserCommentsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserCommentsFetch(
      UserCommentsFetch event, Emitter<UserCommentsState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == UserCommentsStatus.initial) {
      _currentPage = 0;
      final articles =
          await _rssFeedServices.getUserComments(20, 0, event.account);
      return emit(
        state.copyWith(
          synopseRealtimeVUserArticleCommentUser: articles,
          hasReachedMax: false,
          status: UserCommentsStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getUserComments(
        10, 10 + 10 * _currentPage, event.account);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeVUserArticleCommentUser:
              List.of(state.synopseRealtimeVUserArticleCommentUser)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }
}

enum UserCommentsStatus {
  initial,
  success,
  error,
}
