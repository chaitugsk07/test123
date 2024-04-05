import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:synopse/f_repo/models/mod_tag_hierarchy.dart';
import 'package:synopse/f_repo/source_syn_api.dart';

part 'tags_hierarchy_event.dart';
part 'tags_hierarchy_state.dart';

class TagsHierarchyBloc extends Bloc<TagsHierarchyEvent, TagsHierarchyState> {
  final RssFeedServicesFeed _rssFeedServices;

  TagsHierarchyBloc({required RssFeedServicesFeed rssFeedServices})
      : _rssFeedServices = rssFeedServices,
        super(const TagsHierarchyState()) {
    // Initial Event
    on<TagsHierarchyFetch>(
      _onTagsHierarchyFetch,
      transformer: droppable(),
    );
  }

  FutureOr<void> _onTagsHierarchyFetch(
      TagsHierarchyFetch event, Emitter<TagsHierarchyState> emit) async {
    if (state.hasReachedMax) return;

    final articles = await _rssFeedServices.getTaghierarchy();
    if (articles.isEmpty) {
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      return emit(
        state.copyWith(
          synopseArticlesTV4TagsHierarchyRoot:
              List.of(state.synopseArticlesTV4TagsHierarchyRoot)
                ..addAll(articles),
          hasReachedMax: false,
          status: TagsHierarchyStatus.success,
        ),
      );
    }
  }
}

enum TagsHierarchyStatus {
  initial,
  success,
  error,
}
