import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_article_details.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'article_details_event.dart';
part 'article_details_state.dart';

class ArticleDetailsBloc
    extends Bloc<ArticleDetailsEvent, ArticleDetailsState> {
  final RssFeedServicesFeed _rssFeedServices;

  ArticleDetailsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ArticleDetailsState()) {
    // Initial Event
    on<ArticleDetailsFetch>(
      _articleDetailsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _articleDetailsFetch(
      ArticleDetailsFetch event, Emitter<ArticleDetailsState> emit) async {
    final articles =
        await _rssFeedServices.getArticleDetails(event.articleGrouppId);
    if (articles.isEmpty) {
      return emit(state.copyWith(status: ArticleDetailsStatus.error));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV3ArticleGroupsL2:
              List.of(state.synopseArticlesTV3ArticleGroupsL2)
                ..addAll(articles),
          status: ArticleDetailsStatus.success,
        ),
      );
    }
  }
}

enum ArticleDetailsStatus {
  initial,
  success,
  error,
}
