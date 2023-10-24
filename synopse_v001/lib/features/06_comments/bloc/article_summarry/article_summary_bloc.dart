import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/source_articlerss1_comments.dart';

part 'article_summary_state.dart';
part 'article_summary_event.dart';

class ArticleSummaryShortBloc
    extends Bloc<ArticleSummaryShortEvent, ArticleSummaryShortState> {
  final RssFeedServicesDetailComments
      _rssFeedServicesDetailCommentsDetailComments;

  ArticleSummaryShortBloc(
      {required RssFeedServicesDetailComments rssFeedServicesDetailComments})
      : _rssFeedServicesDetailCommentsDetailComments =
            rssFeedServicesDetailComments,
        super(const ArticleSummaryShortState()) {
    // Initial Event
    on<ArticleSummaryShortFetch>(
      _onArticlesShortSummaryFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesShortSummaryFetch(ArticleSummaryShortFetch event,
      Emitter<ArticleSummaryShortState> emit) async {
    if (state.status == ArticlesSummaryStatusStatus.initial) {
      final articles = await _rssFeedServicesDetailCommentsDetailComments
          .getArticleSummaryShort(event.articleId);
      return emit(
        state.copyWith(
          articlesVArticlesMain: articles,
          status: ArticlesSummaryStatusStatus.success,
        ),
      );
    }
  }
}

enum ArticlesSummaryStatusStatus {
  initial,
  success,
  error,
}
