import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_search_results.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  SearchResultsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SearchResultsState()) {
    // Initial Event
    on<SearchResultsFetch>(
      _onSearchResultsFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<SearchResultsRefresh>(
      _onSearchResultsRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSearchResultsFetch(
      SearchResultsFetch event, Emitter<SearchResultsState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == SearchResultsStatus.initial) {
      _currentPage = 0;
      final articles =
          await _rssFeedServices.getArticleSearch(20, 0, event.searchId);
      return emit(
        state.copyWith(
          synopseArticlesFGetSearchArticleGroup: articles,
          hasReachedMax: false,
          status: SearchResultsStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getArticleSearch(
        10, 10 + 10 * _currentPage, event.searchId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesFGetSearchArticleGroup:
              List.of(state.synopseArticlesFGetSearchArticleGroup)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }

  FutureOr<void> _onSearchResultsRefresh(
      SearchResultsRefresh event, Emitter<SearchResultsState> emit) async {
    emit(const SearchResultsState());
    await Future.delayed(const Duration(seconds: 1));
    add(SearchResultsFetch(searchId: event.searchId));
  }
}

enum SearchResultsStatus {
  initial,
  success,
  error,
}
