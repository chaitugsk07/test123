import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_tag_tree.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'tree_tags_event.dart';
part 'tree_tags_state.dart';

class TreeTagsBloc extends Bloc<TreeTagsEvent, TreeTagsState> {
  final RssFeedServicesFeed _rssFeedServices;

  TreeTagsBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const TreeTagsState()) {
    // Initial Event
    on<TreeTagsFetch>(
      _onTreeTagsFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onTreeTagsFetch(
      TreeTagsFetch event, Emitter<TreeTagsState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getTreeTags(event.tagHierarchyId);
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV4TagsHierarchyTree:
              List.of(state.synopseArticlesTV4TagsHierarchyTree)
                ..addAll(articles),
          hasReachedMax: false,
          status: TreeTagsStatus.success,
        ),
      );
    }
  }
}

enum TreeTagsStatus {
  initial,
  success,
  error,
}
