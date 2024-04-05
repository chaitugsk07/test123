import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_search_last3.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'search_last3_event.dart';
part 'search_last3_state.dart';

class SearchLast3Bloc extends Bloc<SearchLast3Event, SearchLast3State> {
  final RssFeedServicesFeed _rssFeedServices;

  SearchLast3Bloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SearchLast3State()) {
    // Initial Event
    on<SearchLast3Fetch>(
      _onSearchLast3Fetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSearchLast3Fetch(
      SearchLast3Fetch event, Emitter<SearchLast3State> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getArticleSearchLast3();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeTTempUserSearch:
              List.of(state.synopseRealtimeTTempUserSearch)..addAll(articles),
          hasReachedMax: false,
          status: SearchLast3sStatus.success,
        ),
      );
    }
  }
}

enum SearchLast3sStatus {
  initial,
  success,
  error,
}
