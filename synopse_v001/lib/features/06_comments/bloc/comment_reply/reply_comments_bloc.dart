import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_comments.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/06_comments/01_model_repo/source_articlerss1_comments.dart';

part 'reply_comments_state.dart';
part 'reply_comments_event.dart';

class ReplyCommentsBloc extends Bloc<ReplyCommentsEvent, ReplyCommentsState> {
  final RssFeedServicesDetailComments
      _rssFeedServicesDetailCommentsDetailComments;
  int _currentPage = 0;

  ReplyCommentsBloc(
      {required RssFeedServicesDetailComments rssFeedServicesDetailComments})
      : _rssFeedServicesDetailCommentsDetailComments =
            rssFeedServicesDetailComments,
        super(const ReplyCommentsState()) {
    // Initial Event
    on<ReplyCommentsFetch>(
      _onArticlesCommentsFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<ReplyCommentsRefresh>(
      _onArticlesCommentsRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesCommentsFetch(
      ReplyCommentsFetch event, Emitter<ReplyCommentsState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == ReplyCommentStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServicesDetailCommentsDetailComments
          .getArticleCommentReply(event.commentId, 20, 0);
      if (articles.length < 20) {
        return emit(
          state.copyWith(
            realtimeVUserArticleComment: articles,
            hasReachedMax: true,
            status: ReplyCommentStatus.success,
          ),
        );
      } else {
        return emit(
          state.copyWith(
            realtimeVUserArticleComment: articles,
            hasReachedMax: false,
            status: ReplyCommentStatus.success,
          ),
        );
      }
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServicesDetailCommentsDetailComments
        .getArticleCommentReply(event.commentId, 10, 10 + 10 * _currentPage);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          realtimeVUserArticleComment:
              List.of(state.realtimeVUserArticleComment)..addAll(articles),
          hasReachedMax: false,
          status: ReplyCommentStatus.success,
        ),
      );
    }
  }

  FutureOr<void> _onArticlesCommentsRefresh(
      ReplyCommentsRefresh event, Emitter<ReplyCommentsState> emit) async {
    emit(const ReplyCommentsState());
    await Future.delayed(const Duration(seconds: 1));
  }
}

enum ReplyCommentStatus {
  initial,
  success,
  error,
}
