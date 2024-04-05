import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_search_with_text_last3.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'search_last3_with_text_event.dart';
part 'search_last3_with_text_state.dart';

class SearchLast3WithTextBloc
    extends Bloc<SearchLast3WithTextEvent, SearchLast3WithTextState> {
  final RssFeedServicesFeed _rssFeedServices;

  SearchLast3WithTextBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const SearchLast3WithTextState()) {
    // Initial Event
    on<SearchLast3WithTextFetch>(
      _onSearchLast3WithTextFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onSearchLast3WithTextFetch(SearchLast3WithTextFetch event,
      Emitter<SearchLast3WithTextState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getArticleSearchLast3WithText();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeTTempUserSearchWithText:
              List.of(state.synopseRealtimeTTempUserSearchWithText)
                ..addAll(articles),
          hasReachedMax: false,
          status: SearchLast3WithTextsStatus.success,
        ),
      );
    }
  }
}

enum SearchLast3WithTextsStatus {
  initial,
  success,
  error,
}
