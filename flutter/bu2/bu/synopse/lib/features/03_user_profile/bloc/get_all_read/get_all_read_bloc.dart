import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_read_event.dart';
part 'get_all_read_state.dart';

class GetAllReadBloc extends Bloc<GetAllReadEvent, GetAllReadState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllReadBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllReadState()) {
    // Initial Event
    on<GetAllReadFetch>(
      _onGetAllReadFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllReadRefresh>(
      _onGetAllReadRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllReadFetch(
      GetAllReadFetch event, Emitter<GetAllReadState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllReadStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.getAll(20, 0, 1);
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail: articles,
          hasReachedMax: false,
          status: GetAllReadStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.getAll(10, 10 + 10 * _currentPage, 1);
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

  FutureOr<void> _onGetAllReadRefresh(
      GetAllReadRefresh event, Emitter<GetAllReadState> emit) async {
    emit(const GetAllReadState(status: GetAllReadStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllReadFetch());
  }
}

enum GetAllReadStatus {
  initial,
  success,
  error,
}
