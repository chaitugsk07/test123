import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_liked_event.dart';
part 'get_all_liked_state.dart';

class GetAllLikedBloc extends Bloc<GetAllLikedEvent, GetAllLikedState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllLikedBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllLikedState()) {
    // Initial Event
    on<GetAllLikedFetch>(
      _onGetAllLikedFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllLikedRefresh>(
      _onGetAllLikedRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllLikedFetch(
      GetAllLikedFetch event, Emitter<GetAllLikedState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllLikedStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getAllLiked(
        20,
        0,
        event.account,
      );
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail: articles,
          hasReachedMax: false,
          status: GetAllLikedStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getAllLiked(
      10,
      10 + 10 * _currentPage,
      event.account,
    );
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

  FutureOr<void> _onGetAllLikedRefresh(
      GetAllLikedRefresh event, Emitter<GetAllLikedState> emit) async {
    emit(const GetAllLikedState(status: GetAllLikedStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllLikedFetch(account: event.account));
  }
}

enum GetAllLikedStatus {
  initial,
  success,
  error,
}
