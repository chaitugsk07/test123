import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:rss1_v9/features/feed/01_model_repo/mod_articalsrss1.dart';
import 'package:rss1_v9/features/feed/01_model_repo/source_articlerss1_api.dart';

part 'articles_rss1_event.dart';
part 'articles_rss1_state.dart';

class ArticlesRss1Bloc extends Bloc<ArticlesRss1Event, ArticlesRss1State> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  ArticlesRss1Bloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ArticlesRss1State()) {
    // Initial Event
    on<ArticlesRss1Fetch>(
      _onArticlesRss1Fetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<ArticlesRss1Refresh>(
      _onArticlesRss1Refresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesRss1Fetch(
      ArticlesRss1Fetch event, Emitter<ArticlesRss1State> emit) async {
    try {
      if (state.hasReachedMax) return;
      if (state.status == ArticlesRss1Status.initial) {
        _currentPage = 0;
        final articles = await _rssFeedServices.getArticleRssFeed(20, 0);

        return emit(
          state.copyWith(
            rss1Articals: articles,
            hasReachedMax: false,
            status: ArticlesRss1Status.success,
          ),
        );
      }
      _currentPage = _currentPage + 1;
      final articles =
          await _rssFeedServices.getArticleRssFeed(10, 10 + 10 * _currentPage);
      if (articles.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      } else {
        return emit(
          state.copyWith(
            rss1Articals: List.of(state.rss1Articals)..addAll(articles),
            hasReachedMax: false,
          ),
        );
      }
    } catch (e) {
      debugPrint("[HATA] [TodoBloc] [_onArticlesRss1Fetch] --> $e");
      return emit(state.copyWith(status: ArticlesRss1Status.error));
    }
  }

  FutureOr<void> _onArticlesRss1Refresh(
      ArticlesRss1Refresh event, Emitter<ArticlesRss1State> emit) async {
    emit(const ArticlesRss1State());
    await Future.delayed(const Duration(seconds: 1));
    add(const ArticlesRss1Fetch());
  }
}

enum ArticlesRss1Status {
  initial,
  success,
  error,
}
