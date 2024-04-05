import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc/get_all/get_all_bloc.dart';
import 'package:synopse/features/04_home/bloc/user_intrests_tags/user_intrests_tags_bloc.dart';

class ForYouS extends StatelessWidget {
  const ForYouS({super.key});

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
        BlocProvider(
          create: (context) => UserIntrestsTagsBloc(
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
    context.read<GetAllBloc>().add(GetAllFetch());

    _scrollController = ScrollController()..addListener(_onScroll);
    final userIntrestsTags = BlocProvider.of<UserIntrestsTagsBloc>(context);
    context.read<UserIntrestsTagsBloc>().add(UserIntrestsTagsFetch());
    hTags = [];
    userIntrestsTags.stream.listen(
      (state) {
        if (state.status == UserIntrestsTagsStatus.success) {
          for (final item in state.synopseRealtimeTUserTagUI) {
            hTags.add(item.tV4TagsHierarchy!.tag);
          }
          setState(() {});
        }
      },
    );
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
      context.read<GetAllBloc>().add(GetAllFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllBloc, GetAllState>(
      builder: (context, getAllState) {
        if (getAllState.status == GetAllStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (getAllState.status == GetAllStatus.success) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<GetAllBloc>().add(GetAllRefresh());
              },
              color: Colors.grey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    getAllState.synopseArticlesTV4ArticleGroupsL2Detail.length,
                itemBuilder: (context, index) {
                  final searchResult = getAllState
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
          );
        } else {
          return Container();
        }
      },
    );
  }
}
