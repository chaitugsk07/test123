import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc_tag_articles/tag_all_bloc.dart';
import 'package:synopse/features/04_home/bloc_tree_tags/tree_tags_bloc.dart';

class TagPage extends StatelessWidget {
  final String tag;
  final int tagIndex1;
  final int tagIndex2;
  final ScrollController primaryScrollController;

  const TagPage(
      {super.key,
      required this.tag,
      required this.tagIndex1,
      required this.tagIndex2,
      required this.primaryScrollController});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TagAllBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => TreeTagsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: TagPages(
        tag: tag,
        tagIndex1: tagIndex1,
        tagIndex2: tagIndex2,
        primaryScrollController: primaryScrollController,
      ),
    );
  }
}

class TagPages extends StatefulWidget {
  final String tag;
  final int tagIndex1;
  final int tagIndex2;
  final ScrollController primaryScrollController;

  const TagPages(
      {super.key,
      required this.tag,
      required this.tagIndex1,
      required this.tagIndex2,
      required this.primaryScrollController});

  @override
  State<TagPages> createState() => _TagPagesState();
}

class _TagPagesState extends State<TagPages> {
  late final ScrollController _scrollController;
  late List<String> hTags;
  @override
  void initState() {
    super.initState();
    context.read<TagAllBloc>().add(TagAllFetch(tag: widget.tag));

    _scrollController = widget.primaryScrollController..addListener(_onScroll);
    context
        .read<TreeTagsBloc>()
        .add(TreeTagsFetch(tagHierarchyId: widget.tagIndex2));

    final treeTagsBloc = BlocProvider.of<TreeTagsBloc>(context);
    hTags = [];
    treeTagsBloc.stream.listen(
      (state) {
        if (state.status == TreeTagsStatus.success) {
          for (final item in state.synopseArticlesTV4TagsHierarchyTree) {
            if (item.tag != widget.tag) {
              hTags.add(item.tag);
            }
          }
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<TagAllBloc>().add(TagAllFetch(tag: widget.tag));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagAllBloc, TagAllState>(
      builder: (context, tagAllState) {
        if (tagAllState.status == TagAllStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (tagAllState.status == TagAllStatus.success) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<TagAllBloc>().add(TagAllRefresh(tag: widget.tag));
              },
              color: Colors.grey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    tagAllState.synopseArticlesTV4ArticleGroupsL2Detail.length,
                itemBuilder: (context, index) {
                  final searchResult = tagAllState
                      .synopseArticlesTV4ArticleGroupsL2Detail[index];
                  final images = searchResult.imageUrls;
                  images.shuffle();
                  final logoUrls = searchResult.logoUrls;
                  logoUrls.shuffle();
                  final articleGroupId = searchResult.articleGroupId;
                  final lastUpdatedat =
                      searchResult.articleDetailLink!.updatedAtFormatted;
                  final title = searchResult.title;
                  final likescount = searchResult.articleDetailLink!.likesCount;
                  final viewcount = searchResult.articleDetailLink!.viewsCount;
                  final commentcount =
                      searchResult.articleDetailLink!.commentsCount;
                  final isliked = searchResult
                              .tUserArticleLikesAggregate!.aggregate!.count ==
                          0
                      ? false
                      : true;
                  final isviewed = searchResult
                              .tUserArticleViewsAggregate!.aggregate!.count ==
                          0
                      ? false
                      : true;
                  final iscommented = searchResult
                              .tUserArticleCommentsAggregate!
                              .aggregate!
                              .count ==
                          0
                      ? false
                      : true;
                  final articlecount =
                      searchResult.articleDetailLink!.articleCount;

                  String htag = 'na';
                  if (index > 10 &&
                      index % 15 == 0 &&
                      (index / 15) < hTags.length + 1) {
                    htag = hTags[index ~/ 15 - 1];
                  }
                  return FeedTileM(
                    ind: index,
                    articleGroupid: articleGroupId,
                    images: images,
                    logoUrls: logoUrls,
                    lastUpdatedat: lastUpdatedat,
                    title: title,
                    likesCount: likescount,
                    viewsCount: viewcount,
                    commentsCount: commentcount,
                    isLiked: isliked,
                    isViewed: isviewed,
                    isCommented: iscommented,
                    articleCount: articlecount,
                    type: 2,
                    hTag: htag,
                    isLoggedin: true,
                  );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
