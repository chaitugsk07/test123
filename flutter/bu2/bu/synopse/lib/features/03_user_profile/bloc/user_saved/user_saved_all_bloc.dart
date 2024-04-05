import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_bookmarked.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'user_saved_all_event.dart';
part 'user_saved_all_state.dart';

class UserSavedBloc extends Bloc<UserSavedEvent, UserSavedState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  UserSavedBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const UserSavedState()) {
    // Initial Event
    on<UserSavedFetch>(
      _onUserSavedFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onUserSavedFetch(
      UserSavedFetch event, Emitter<UserSavedState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == UserSavedStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getArticleSaved(20, 0);
      return emit(
        state.copyWith(
          synopseRealtimeTUserArticleBookmark: articles,
          hasReachedMax: false,
          status: UserSavedStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.getArticleSaved(10, 10 + 10 * _currentPage);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeTUserArticleBookmark:
              List.of(state.synopseRealtimeTUserArticleBookmark)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }
}

enum UserSavedStatus {
  initial,
  success,
  error,
}
