import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc/get_all_vector/get_all_vector_bloc.dart';
import 'package:synopse/features/04_home/bloc/root_tags/root_tags_bloc.dart';

class ForYouVectorS extends StatelessWidget {
  const ForYouVectorS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllVectorBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RootTagsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const ForYou(),
    );
  }
}

class ForYou extends StatefulWidget {
  const ForYou({super.key});

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  late final ScrollController _scrollController;
  late List<String> hTags;
  @override
  void initState() {
    super.initState();
    context.read<GetAllVectorBloc>().add(GetAllVectorFetch());

    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RootTagsBloc>().add(RootTagsFetch());

    final rootTagsBloc = BlocProvider.of<RootTagsBloc>(context);
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
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<GetAllVectorBloc>().add(GetAllVectorFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllVectorBloc, GetAllVectorState>(
      builder: (context, getAllVectorState) {
        if (getAllVectorState.status == GetAllVectorStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (getAllVectorState.status == GetAllVectorStatus.success) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<GetAllVectorBloc>().add(GetAllVectorRefresh());
              },
              color: Colors.grey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: getAllVectorState
                    .synopseArticlesFGetSearchArticleGroup.length,
                itemBuilder: (context, index) {
                  final searchResult = getAllVectorState
                      .synopseArticlesFGetSearchArticleGroup[index]
                      .tV4ArticleGroupsL2Detail!;
                  final images = searchResult.imageUrls;
                  images.shuffle();
                  final logoUrls = searchResult.logoUrls;
                  logoUrls.shuffle();
                  final articleGroupId = getAllVectorState
                      .synopseArticlesFGetSearchArticleGroup[index]
                      .articleGroupId;
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
                  final isbookmarked = searchResult
                              .tUserArticleBookmarksAggregate!
                              .aggregate!
                              .count ==
                          0
                      ? false
                      : true;
                  final articlecount =
                      searchResult.articleDetailLink!.articleCount;
                  String htag = 'na';
                  if (index % 5 == 0 && (index / 5) < hTags.length) {
                    htag = hTags[index ~/ 5];
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
                    isbookmarked: isbookmarked,
                    articleCount: articlecount,
                    type: 1,
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
