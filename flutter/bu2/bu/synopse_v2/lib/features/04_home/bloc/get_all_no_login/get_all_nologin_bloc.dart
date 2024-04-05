import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall_nologin.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';

part 'get_all_nologin_event.dart';
part 'get_all_nologin_state.dart';

class GetAllNoLoginBloc extends Bloc<GetAllNoLoginEvent, GetAllNoLoginState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllNoLoginBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllNoLoginState()) {
    // Initial Event
    on<GetAllNoLoginFetch>(
      _onGetAllNoLoginFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllNoLoginRefresh>(
      _onGetAllNoLoginRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllNoLoginFetch(
      GetAllNoLoginFetch event, Emitter<GetAllNoLoginState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllNoLoginStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getAllNoLogin(20, 0);
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail: articles,
          hasReachedMax: false,
          status: GetAllNoLoginStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.getAllNoLogin(10, 10 + 10 * _currentPage);
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

  FutureOr<void> _onGetAllNoLoginRefresh(
      GetAllNoLoginRefresh event, Emitter<GetAllNoLoginState> emit) async {
    emit(const GetAllNoLoginState(status: GetAllNoLoginStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllNoLoginFetch());
  }
}

enum GetAllNoLoginStatus {
  initial,
  success,
  error,
}
