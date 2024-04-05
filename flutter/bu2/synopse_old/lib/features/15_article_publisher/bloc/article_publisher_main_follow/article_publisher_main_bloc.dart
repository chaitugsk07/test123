import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_publishers_main.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'article_publisher_main_event.dart';
part 'article_publisher_main_state.dart';

class ArticlePublisherMainBloc
    extends Bloc<ArticlePublisherMainEvent, ArticlePublisherMainState> {
  final RssFeedServicesFeed _rssFeedServices;

  ArticlePublisherMainBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ArticlePublisherMainState()) {
    // Initial Event
    on<ArticlePublisherMainFetch>(
      _onArticlePublisherMainFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onArticlePublisherMainFetch(ArticlePublisherMainFetch event,
      Emitter<ArticlePublisherMainState> emit) async {
    if (state.hasReachedMax) return;

    final articles =
        await _rssFeedServices.getArticlePublishersMain(event.logoUrl);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV1Outlet: List.of(state.synopseArticlesTV1Outlet)
            ..addAll(articles),
          hasReachedMax: false,
          status: ArticlePublisherMainStatus.success,
        ),
      );
    }
  }
}

enum ArticlePublisherMainStatus {
  initial,
  success,
  error,
}
