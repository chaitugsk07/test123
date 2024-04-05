import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc_get_all/get_all_bloc.dart';

class ForYouS extends StatelessWidget {
  final ScrollController primaryScrollController;
  final List<String> hTags;

  const ForYouS(
      {super.key, required this.primaryScrollController, required this.hTags});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ForYou(
        primaryScrollController: primaryScrollController,
        hTags: hTags,
      ),
    );
  }
}

class ForYou extends StatefulWidget {
  final ScrollController primaryScrollController;
  final List<String> hTags;

  const ForYou(
      {super.key, required this.primaryScrollController, required this.hTags});

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<GetAllBloc>().add(GetAllFetch());

    _scrollController = widget.primaryScrollController..addListener(_onScroll);

    /*final rootTagsBloc = BlocProvider.of<RootTagsBloc>(context);
    hTags = [];
    rootTagsBloc.stream.listen(
      (state) {
        if (state.status == RootTagsStatus.success) {
          for (final item in state.synopseArticlesTV4TagsHierarchyRootForYou) {
            hTags.add(item.tag);
          }
          setState(() {});
        }
      },
    );*/
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
      context.read<GetAllBloc>().add(GetAllFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width >= 1500) {
      context.read<GetAllBloc>().add(GetAllFetch());
    }
    return BlocBuilder<GetAllBloc, GetAllState>(
      builder: (context, getAllState) {
        if (getAllState.status == GetAllStatus.initial) {
          return const Center(
            child: PageLoading(
              title: 'For You',
            ),
          );
        } else if (getAllState.status == GetAllStatus.success) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<GetAllBloc>().add(GetAllRefresh());
              },
              color: Colors.grey,
              child: Column(
                children: [
                  if (screenSize.width > 1400)
                    Expanded(
                      child: MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: getAllState
                            .synopseArticlesTV4ArticleGroupsL2Detail.length,
                        itemBuilder: (context, index) {
                          final searchResult = getAllState
                              .synopseArticlesTV4ArticleGroupsL2Detail[index];
                          final images = searchResult.imageUrls;
                          images.shuffle();
                          final logoUrls = searchResult.logoUrls;
                          logoUrls.shuffle();
                          final articleGroupId = searchResult.articleGroupId;
                          final lastUpdatedat = searchResult
                              .articleDetailLink!.updatedAtFormatted;
                          final title = searchResult.title;
                          final likescount =
                              searchResult.articleDetailLink!.likesCount;
                          final viewcount =
                              searchResult.articleDetailLink!.viewsCount;
                          final commentcount =
                              searchResult.articleDetailLink!.commentsCount;
                          final isliked = searchResult
                                      .tUserArticleLikesAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final isviewed = searchResult
                                      .tUserArticleViewsAggregate!
                                      .aggregate!
                                      .count ==
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
                          // if (index > 10 &&
                          //     index % 15 == 0 &&
                          //     (index / 15) < hTags.length + 1) {
                          //   htag = hTags[index ~/ 15 - 1];
                          // }
                          return Column(
                            children: [
                              FeedTileM(
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
                                type: 1,
                                hTag: htag,
                                isLoggedin: true,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  else if (screenSize.width > 1000)
                    Expanded(
                      child: MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: getAllState
                            .synopseArticlesTV4ArticleGroupsL2Detail.length,
                        itemBuilder: (context, index) {
                          final searchResult = getAllState
                              .synopseArticlesTV4ArticleGroupsL2Detail[index];
                          final images = searchResult.imageUrls;
                          images.shuffle();
                          final logoUrls = searchResult.logoUrls;
                          logoUrls.shuffle();
                          final articleGroupId = searchResult.articleGroupId;
                          final lastUpdatedat = searchResult
                              .articleDetailLink!.updatedAtFormatted;
                          final title = searchResult.title;
                          final likescount =
                              searchResult.articleDetailLink!.likesCount;
                          final viewcount =
                              searchResult.articleDetailLink!.viewsCount;
                          final commentcount =
                              searchResult.articleDetailLink!.commentsCount;
                          final isliked = searchResult
                                      .tUserArticleLikesAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final isviewed = searchResult
                                      .tUserArticleViewsAggregate!
                                      .aggregate!
                                      .count ==
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
                          // if (index > 10 &&
                          //     index % 15 == 0 &&
                          //     (index / 15) < hTags.length + 1) {
                          //   htag = hTags[index ~/ 15 - 1];
                          // }
                          return Column(
                            children: [
                              FeedTileM(
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
                                type: 1,
                                hTag: htag,
                                isLoggedin: true,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: getAllState
                            .synopseArticlesTV4ArticleGroupsL2Detail.length,
                        itemBuilder: (context, index) {
                          final searchResult = getAllState
                              .synopseArticlesTV4ArticleGroupsL2Detail[index];
                          final images = searchResult.imageUrls;
                          images.shuffle();
                          final logoUrls = searchResult.logoUrls;
                          logoUrls.shuffle();
                          final articleGroupId = searchResult.articleGroupId;
                          final lastUpdatedat = searchResult
                              .articleDetailLink!.updatedAtFormatted;
                          final title = searchResult.title;
                          final likescount =
                              searchResult.articleDetailLink!.likesCount;
                          final viewcount =
                              searchResult.articleDetailLink!.viewsCount;
                          final commentcount =
                              searchResult.articleDetailLink!.commentsCount;
                          final isliked = searchResult
                                      .tUserArticleLikesAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final isviewed = searchResult
                                      .tUserArticleViewsAggregate!
                                      .aggregate!
                                      .count ==
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
                              (index / 15) < widget.hTags.length + 1) {
                            htag = widget.hTags[index ~/ 15 - 1];
                          }
                          return Column(
                            children: [
                              FeedTileM(
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
                                type: 1,
                                hTag: htag,
                                isLoggedin: true,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
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
