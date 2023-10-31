import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_comments.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/06_comments/01_model_repo/source_articlerss1_comments.dart';

part 'article_comments_state.dart';
part 'article_comments_event.dart';

class ArticleCommentsBloc
    extends Bloc<ArticleCommentsEvent, ArticleCommentsState> {
  final RssFeedServicesDetailComments
      _rssFeedServicesDetailCommentsDetailComments;
  int _currentPage = 0;

  ArticleCommentsBloc(
      {required RssFeedServicesDetailComments rssFeedServicesDetailComments})
      : _rssFeedServicesDetailCommentsDetailComments =
            rssFeedServicesDetailComments,
        super(const ArticleCommentsState()) {
    // Initial Event
    on<ArticleCommentsFetch>(
      _onArticlesCommentsFetch,
      transformer: droppable(),
    );

    // Refresh Event
    on<ArticleCommentsRefresh>(
      _onArticlesCommentsRefresh,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesCommentsFetch(
      ArticleCommentsFetch event, Emitter<ArticleCommentsState> emit) async {
    if (state.hasReachedMax) return;
    if (state.status == ArticlesCommentStatus.initial) {
      _currentPage = 0;
      final articles = await _rssFeedServicesDetailCommentsDetailComments
          .getArticleComment(event.articleId, 20, 0);
      return emit(
        state.copyWith(
          articlesTV1ArticalsGroupsL1Comment: articles,
          hasReachedMax: false,
          status: ArticlesCommentStatus.success,
        ),
      );
    }
    _currentPage = _currentPage + 1;
    final articles = await _rssFeedServicesDetailCommentsDetailComments
        .getArticleComment(event.articleId, 10, 10 + 10 * _currentPage);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          articlesTV1ArticalsGroupsL1Comment:
              List.of(state.articlesTV1ArticalsGroupsL1Comment)
                ..addAll(articles),
          hasReachedMax: false,
          status: ArticlesCommentStatus.success,
        ),
      );
    }
  }

  FutureOr<void> _onArticlesCommentsRefresh(
      ArticleCommentsRefresh event, Emitter<ArticleCommentsState> emit) async {
    emit(const ArticleCommentsState());
    await Future.delayed(const Duration(seconds: 1));
  }
}

enum ArticlesCommentStatus {
  initial,
  success,
  error,
}
