import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_searchid.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RssFeedServicesFeed _rssFeedServices;

  SearchBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SearchState()) {
    // Initial Event
    on<SearchFetch>(
      _onSearchFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSearchFetch(
      SearchFetch event, Emitter<SearchState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getSearchID(event.search);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeGetEmbedding:
              List.of(state.synopseRealtimeGetEmbedding)..addAll(articles),
          hasReachedMax: false,
          status: SearchStatus.success,
        ),
      );
    }
  }
}

enum SearchStatus {
  initial,
  success,
  error,
}
