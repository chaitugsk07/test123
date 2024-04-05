import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_search_results.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_vector_event.dart';
part 'get_all_vector_state.dart';

class GetAllVectorBloc extends Bloc<GetAllVectorEvent, GetAllVectorState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllVectorBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllVectorState()) {
    // Initial Event
    on<GetAllVectorFetch>(
      _onGetAllVectorFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllVectorRefresh>(
      _onGetAllVectorRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllVectorFetch(
      GetAllVectorFetch event, Emitter<GetAllVectorState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllVectorStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getUserSearch(20, 0);
      return emit(
        state.copyWith(
          synopseArticlesFGetSearchArticleGroup: articles,
          hasReachedMax: false,
          status: GetAllVectorStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.getUserSearch(10, 10 + 10 * _currentPage);
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

  FutureOr<void> _onGetAllVectorRefresh(
      GetAllVectorRefresh event, Emitter<GetAllVectorState> emit) async {
    emit(const GetAllVectorState(status: GetAllVectorStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllVectorFetch());
  }
}

enum GetAllVectorStatus {
  initial,
  success,
  error,
}
