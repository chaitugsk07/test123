import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_inshorts.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_inshorts_event.dart';
part 'get_all_inshorts_state.dart';

class GetAllInShortsBloc
    extends Bloc<GetAllInShortsEvent, GetAllInShortsState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;
  int _currentPageNa = 0;

  GetAllInShortsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllInShortsState()) {
    // Initial Event
    on<GetAllInShortsFetch>(
      _onGetAllInShortsFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllInShortsRefresh>(
      _onGetAllInShortsRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllInShortsFetch(
      GetAllInShortsFetch event, Emitter<GetAllInShortsState> emit) async {
    if (event.noTags) {
      if (state.hasReachedMax) return;
      if (state.status == GetAllInShortsStatus.initial) {
        _currentPage = 0;
        final articles = await _rssFeedServices.getAllInShortsNO(20, 0);
        return emit(
          state.copyWith(
            synopseArticlesTV4ArticleGroupsL2DetailInShorts: articles,
            hasReachedMax: false,
            status: GetAllInShortsStatus.success,
          ),
        );
      }
      _currentPage = _currentPage + 1;
      final articles =
          await _rssFeedServices.getAllInShortsNO(10, 10 + 10 * _currentPage);
      if (articles.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      } else {
        return emit(
          state.copyWith(
            synopseArticlesTV4ArticleGroupsL2DetailInShorts:
                List.of(state.synopseArticlesTV4ArticleGroupsL2DetailInShorts)
                  ..addAll(articles),
            hasReachedMax: false,
          ),
        );
      }
    } else {
      if (state.hasReachedMax) return;
      if (state.hasReachedMaxNa) {
        _currentPageNa = _currentPageNa + 1;
        final articles2 = await _rssFeedServices.getAllInShortsNa(
            10, _currentPage * 2 + 2 + 10 * _currentPageNa, event.tags);
        if (articles2.isEmpty) {
          return emit(state.copyWith(hasReachedMaxNa: true));
        }
        return emit(
          state.copyWith(
            synopseArticlesTV4ArticleGroupsL2DetailInShorts:
                List.of(state.synopseArticlesTV4ArticleGroupsL2DetailInShorts)
                  ..addAll(articles2),
            hasReachedMax: false,
            hasReachedMaxNa: true,
          ),
        );
      }
      if (state.status == GetAllInShortsStatus.initial) {
        _currentPage = 0;
        final articles =
            await _rssFeedServices.getAllInShorts(8, 0, event.tags);
        final articles2 =
            await _rssFeedServices.getAllInShortsNa(2, 0, event.tags);
        return emit(
          state.copyWith(
            synopseArticlesTV4ArticleGroupsL2DetailInShorts: articles
              ..addAll(articles2),
            hasReachedMax: false,
            hasReachedMaxNa: false,
            status: GetAllInShortsStatus.success,
          ),
        );
      }
      _currentPage = _currentPage + 1;

      final articles = await _rssFeedServices.getAllInShorts(
          8, 8 + 8 * _currentPage, event.tags);
      final articles2 = await _rssFeedServices.getAllInShortsNa(
          2, 2 + 2 * _currentPage, event.tags);
      if (articles.isEmpty) {
        return emit(state.copyWith(hasReachedMaxNa: true));
      }
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2DetailInShorts:
              List.of(state.synopseArticlesTV4ArticleGroupsL2DetailInShorts)
                ..addAll(articles)
                ..addAll(articles2),
          hasReachedMax: false,
          hasReachedMaxNa: false,
        ),
      );
    }
  }

  FutureOr<void> _onGetAllInShortsRefresh(
      GetAllInShortsRefresh event, Emitter<GetAllInShortsState> emit) async {
    emit(const GetAllInShortsState(status: GetAllInShortsStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllInShortsFetch(tags: event.tags, noTags: event.noTags));
  }
}

enum GetAllInShortsStatus {
  initial,
  success,
  error,
}
