import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'tag_all_event.dart';
part 'tag_all_state.dart';

class TagAllBloc extends Bloc<TagAllEvent, TagAllState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  TagAllBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const TagAllState()) {
    // Initial Event
    on<TagAllFetch>(
      _onTagAllFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<TagAllRefresh>(
      _onTagAllRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onTagAllFetch(
      TagAllFetch event, Emitter<TagAllState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == TagAllStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServices.gettagAll(20, 0, event.tag);
      return emit(
        state.copyWith(
          synopseArticlesTV4ArticleGroupsL2Detail: articles,
          hasReachedMax: false,
          status: TagAllStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles =
        await _rssFeedServices.gettagAll(10, 10 + 10 * _currentPage, event.tag);
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

  FutureOr<void> _onTagAllRefresh(
      TagAllRefresh event, Emitter<TagAllState> emit) async {
    emit(const TagAllState(status: TagAllStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(TagAllFetch(tag: event.tag));
  }
}

enum TagAllStatus {
  initial,
  success,
  error,
}
