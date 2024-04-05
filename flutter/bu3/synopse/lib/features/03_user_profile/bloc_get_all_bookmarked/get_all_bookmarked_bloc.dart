import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_bookmarked_event.dart';
part 'get_all_bookmarked_state.dart';

class GetAllBookmarkedBloc
    extends Bloc<GetAllBookmarkedEvent, GetAllBookmarkedState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllBookmarkedBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllBookmarkedState()) {
    // Initial Event
    on<GetAllBookmarkedFetch>(
      _onGetAllBookmarkedFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllBookmarkedRefresh>(
      _onGetAllBookmarkedRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllBookmarkedFetch(
      GetAllBookmarkedFetch event, Emitter<GetAllBookmarkedState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllBookmarkedStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getAllBookmarked(20, 0);
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail: articles,
          hasReachedMax: false,
          status: GetAllBookmarkedStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.getAllBookmarked(10, 10 + 10 * _currentPage);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail:
              List.of(state.synopseArticlesTV4ArticleGroupsL2Detail)
                ..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }

  FutureOr<void> _onGetAllBookmarkedRefresh(GetAllBookmarkedRefresh event,
      Emitter<GetAllBookmarkedState> emit) async {
    emit(const GetAllBookmarkedState(status: GetAllBookmarkedStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllBookmarkedFetch());
  }
}

enum GetAllBookmarkedStatus {
  initial,
  success,
  error,
}
