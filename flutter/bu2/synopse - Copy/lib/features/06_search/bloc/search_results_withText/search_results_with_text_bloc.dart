import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_search_with_text.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'search_results_with_text_event.dart';
part 'search_results_with_text_state.dart';

class SearchResultsWithTextBloc
    extends Bloc<SearchResultsWithTextEvent, SearchResultsWithTextState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  SearchResultsWithTextBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SearchResultsWithTextState()) {
    // Initial Event
    on<SearchResultsWithTextFetch>(
      _onSearchResultsWithTextFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<SearchResultsWithTextRefresh>(
      _onSearchResultsWithTextRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSearchResultsWithTextFetch(SearchResultsWithTextFetch event,
      Emitter<SearchResultsWithTextState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == SearchResultsWithTextStatus.initial) {
      _currentPage = 0;
      final articles =
          await _rssFeedServices.getArticleSearchWithText(20, 0, event.search);
      return emit(
        state.copyWith(
          synopseArticlesVArticlesGroupDetailsSearch: articles,
          hasReachedMax: false,
          status: SearchResultsWithTextStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getArticleSearchWithText(
        10, 10 + 10 * _currentPage, event.search);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesVArticlesGroupDetailsSearch:
              List.of(state.synopseArticlesVArticlesGroupDetailsSearch)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }

  FutureOr<void> _onSearchResultsWithTextRefresh(
      SearchResultsWithTextRefresh event,
      Emitter<SearchResultsWithTextState> emit) async {
    emit(const SearchResultsWithTextState());
    await Future.delayed(const Duration(seconds: 1));
    add(SearchResultsWithTextFetch(search: event.search));
  }
}

enum SearchResultsWithTextStatus {
  initial,
  success,
  error,
}
