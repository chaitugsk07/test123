import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_05_followup.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'article_followup_event.dart';
part 'article_followup_state.dart';

class ArticleFollowupBloc
    extends Bloc<ArticleFollowupEvent, ArticleFollowupState> {
  final RssFeedServicesFeed _rssFeedServices;

  ArticleFollowupBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const ArticleFollowupState()) {
    // Initial Event
    on<ArticleFollowupFetch>(
      _articleFollowupFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _articleFollowupFetch(
      ArticleFollowupFetch event, Emitter<ArticleFollowupState> emit) async {
    final articles =
        await _rssFeedServices.getAllFollowUps(event.articleFollowup);
    if (articles.isEmpty) {
      return emit(state.copyWith(status: ArticleFollowupStatus.error));
    } else {
      return emit(
        state.copyWith(
          synopseRealtimeVV10UsersFollowUp:
              List.of(state.synopseRealtimeVV10UsersFollowUp)..addAll(articles),
          status: ArticleFollowupStatus.success,
        ),
      );
    }
  }
}

enum ArticleFollowupStatus {
  initial,
  success,
  error,
}
