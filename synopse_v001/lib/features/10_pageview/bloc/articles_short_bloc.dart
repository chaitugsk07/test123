import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_comments.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/06_comments/01_model_repo/source_articlerss1_comments.dart';
import 'package:synopse_v001/features/10_pageview/01_model_repo/source_articlerss1page_api.dart';

part 'articles_short_state.dart';
part 'articles_short_event.dart';

class ArticleShortBloc extends Bloc<ArticleShortEvent, ArticleShortState> {
  final RssFeedPageView _rssFeedPageView;
  int _currentPage = 0;

  ArticleShortBloc({required RssFeedPageView rssFeedPageView})
      : _rssFeedPageView = rssFeedPageView,
        super(const ArticleShortState()) {
    // Initial Event
    on<ArticleShortFetch>(
      _onArticlesShortFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<ArticleShortRefresh>(
      _onArticlesCommentsRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesShortFetch(
      ArticleShortFetch event, Emitter<ArticleShortState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == ArticleShortStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedPageView.getArticleRssFeed(5, 0);
      if (articles.length < 5) {
        return emit(
          state.copyWith(
            articlesVArticlesMain: articles,
            hasReachedMax: true,
            status: ArticleShortStatus.success,
          ),
        );
      } else {
        return emit(
          state.copyWith(
            articlesVArticlesMain: articles,
            hasReachedMax: false,
            status: ArticleShortStatus.success,
          ),
        );
      }
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedPageView.getArticleRssFeed(5, 5 * _currentPage);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          articlesVArticlesMain: List.of(state.articlesVArticlesMain)
            ..addAll(articles),
          hasReachedMax: false,
          status: ArticleShortStatus.success,
        ),
      );
    }
  }

  FutureOr<void> _onArticlesCommentsRefresh(
      ArticleShortRefresh event, Emitter<ArticleShortState> emit) async {
    emit(const ArticleShortState());
    await Future.delayed(const Duration(seconds: 1));
  }
}

enum ArticleShortStatus {
  initial,
  success,
  error,
}
