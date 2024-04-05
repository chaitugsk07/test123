import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_event.dart';
part 'get_all_state.dart';

class GetAllBloc extends Bloc<GetAllEvent, GetAllState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllState()) {
    // Initial Event
    on<GetAllFetch>(
      _onGetAllFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllRefresh>(
      _onGetAllRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllFetch(
      GetAllFetch event, Emitter<GetAllState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getAll(20, 0, 0);
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail: articles,
          hasReachedMax: false,
          status: GetAllStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.getAll(10, 10 + 10 * _currentPage, 0);
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

  FutureOr<void> _onGetAllRefresh(
      GetAllRefresh event, Emitter<GetAllState> emit) async {
    emit(const GetAllState(status: GetAllStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllFetch());
  }
}

enum GetAllStatus {
  initial,
  success,
  error,
}
