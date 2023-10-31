import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse_v1/features/article_detail/01_model_repo/mod_articalsrss1_detail.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:synopse_v1/features/article_detail/01_model_repo/source_articlerss1_details_api.dart';

part 'article_detail_event.dart';
part 'article_detail_state.dart';

class ArticlesRss1DetailBloc
    extends Bloc<ArticlesRss1DetailEvent, ArticlesRss1DetailState> {
  final RssFeedServicesDetail _rssFeedServicesDetail;
  ArticlesRss1DetailBloc({required RssFeedServicesDetail rssFeedServicesDetail})
      : _rssFeedServicesDetail = rssFeedServicesDetail,
        super(const ArticlesRss1DetailState()) {
    on<ArticlesRss1DetailFetch>(
      _onArticlesRss1DetailFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlesRss1DetailFetch(ArticlesRss1DetailFetch event,
      Emitter<ArticlesRss1DetailState> emit) async {
    if (state.status == ArticlesRss1DetailStatus.initial) {
      final articleDetails = await _rssFeedServicesDetail
          .getArticleRssAricleDetail(event.postLink1);

      return emit(
        state.copyWith(
          rss1ArticlesDetail: articleDetails,
          status: ArticlesRss1DetailStatus.success,
        ),
      );
    }
  }
}

enum ArticlesRss1DetailStatus {
  initial,
  success,
  error,
}
