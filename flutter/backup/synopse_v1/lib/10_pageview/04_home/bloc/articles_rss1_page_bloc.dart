import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/07_pageview/04_home/01_model_repo/mod_articalsrss1page.dart';
import 'package:synopse_v001/features/07_pageview/04_home/01_model_repo/source_articlerss1page_api.dart';

part 'articles_rss1_page_event.dart';
part 'articles_rss1_page_state.dart';

class ArticlesRss1PageBloc
    extends Bloc<ArticlesRss1PageEvent, ArticlesRss1PageState> {
  final RssFeedPageView _rssFeedPageView;
  int _currentPage = 0;

  ArticlesRss1PageBloc({required RssFeedPageView rssFeedPageView})
      : _rssFeedPageView = rssFeedPageView,
        super(const ArticlesRss1PageState()) {
    // Initial Event
    on<ArticlesRss1PageFetch>(
      _onArticlesRss1PageFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesRss1PageFetch(
      ArticlesRss1PageFetch event, Emitter<ArticlesRss1PageState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == ArticlesRss1PageStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedPageView.getArticleRssFeed(5, 0);
      return emit(
        state.copyWith(
          articlesTV1ArticalsGroupsL1DetailPage: articles,
          hasReachedMax: false,
          status: ArticlesRss1PageStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedPageView.getArticleRssFeed(5, 5 * _currentPage);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          articlesTV1ArticalsGroupsL1DetailPage:
              List.of(state.articlesTV1ArticalsGroupsL1DetailPage)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }
}

enum ArticlesRss1PageStatus {
  initial,
  success,
  error,
}
