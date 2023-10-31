import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:synopse_v1/features/article_group_feed/01_model_repo/mod_articalsrss1.dart';
import 'package:synopse_v1/features/article_group_feed/01_model_repo/source_articlerss1_api.dart';
part 'articlesgroup_rss1_event.dart';
part 'articlesgroup_rss1_state.dart';

class ArticlesGroupRss1Bloc extends Bloc<ArticlesGroupRss1Event, ArticlesGroupRss1State> {
  final RssFeedServicesGroupFeed _rssFeedServicesGroupFeed;
  int _currentPage = 0;

  ArticlesGroupRss1Bloc({required RssFeedServicesGroupFeed rssFeedServicesGroupFeed})
      : _rssFeedServicesGroupFeed = rssFeedServicesGroupFeed,
        super(const ArticlesGroupRss1State()) {
    // Initial Event
    on<ArticlesGroupRss1Fetch>(
      _onArticlesGroupRss1Fetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<ArticlesGroupRss1Refresh>(
      _onArticlesGroupRss1Refresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesGroupRss1Fetch(
      ArticlesGroupRss1Fetch event, Emitter<ArticlesGroupRss1State> emit) async {
    try {
      if (state.hasReachedMax) return;
      if (state.status == ArticlesGroupRss1Status.initial) {
        _currentPage = 0;
        
        final articles = await _rssFeedServicesGroupFeed.getArticleGroupRssFeed(20, 0);
        //print("articles");
        return emit(
          state.copyWith(
            articlesTV1ArticalsGroupsL1Detail: articles,
            hasReachedMax: false,
            status: ArticlesGroupRss1Status.success,
          ),
        );
      }
      _currentPage = _currentPage + 1;
      final articles =
          await _rssFeedServicesGroupFeed.getArticleGroupRssFeed(10, 10 + 10 * _currentPage);
      if (articles.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      } else {
        return emit(
          state.copyWith(
            articlesTV1ArticalsGroupsL1Detail: List.of(state.articlesTV1ArticalsGroupsL1Detail)..addAll(articles),
            hasReachedMax: false,
          ),
        );
      }
    } catch (e) {
      debugPrint("[HATA] [TodoBloc] [_onArticlesRss1Fetch] --> $e");
      return emit(state.copyWith(status: ArticlesGroupRss1Status.error));
    }
  }

  FutureOr<void> _onArticlesGroupRss1Refresh(
      ArticlesGroupRss1Refresh event, Emitter<ArticlesGroupRss1State> emit) async {
    emit(const ArticlesGroupRss1State());
    await Future.delayed(const Duration(seconds: 1));
    add(const ArticlesGroupRss1Fetch());
  }
}

enum ArticlesGroupRss1Status {
  initial,
  success,
  error,
}
