import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_publisher.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'get_all_publisher_event.dart';
part 'get_all_publisher_state.dart';

class GetAllPublisherBloc
    extends Bloc<GetAllPublisherEvent, GetAllPublisherState> {
  final RssFeedServicesFeed _rssFeedServices;
  int _currentPage = 0;

  GetAllPublisherBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const GetAllPublisherState()) {
    // Initial Event
    on<GetAllPublisherFetch>(
      _onGetAllPublisherFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<GetAllPublisherRefresh>(
      _onGetAllPublisherRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onGetAllPublisherFetch(
      GetAllPublisherFetch event, Emitter<GetAllPublisherState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == GetAllPublisherStatus.initial) {
      _currentPage = 0;
      final articles =
          await _rssFeedServices.getArticlePublisher(20, 0, event.outletId);
      return emit(
        state.copyWith(
          synopseArticlesTV1Rss1ArticleF1: articles,
          hasReachedMax: false,
          status: GetAllPublisherStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServices.getArticlePublisher(
        10, 10 + 10 * _currentPage, event.outletId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV1Rss1ArticleF1:
              List.of(state.synopseArticlesTV1Rss1ArticleF1)..addAll(articles),
          hasReachedMax: false,
        ),
      );
    }
  }

  FutureOr<void> _onGetAllPublisherRefresh(
      GetAllPublisherRefresh event, Emitter<GetAllPublisherState> emit) async {
    emit(const GetAllPublisherState(status: GetAllPublisherStatus.initial));
    await Future.delayed(const Duration(seconds: 2));
    add(GetAllPublisherFetch(outletId: event.outletId));
  }
}

enum GetAllPublisherStatus {
  initial,
  success,
  error,
}
