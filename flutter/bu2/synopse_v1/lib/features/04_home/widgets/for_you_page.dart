import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc_get_all/get_all_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_intrests_tags/user_intrests_tags_bloc.dart';

class ForYouS extends StatelessWidget {
  final ScrollController primaryScrollController;

  const ForYouS({super.key, required this.primaryScrollController});

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
      child: ForYou(
        primaryScrollController: primaryScrollController,
      ),
    );
  }
}

class ForYou extends StatefulWidget {
  final ScrollController primaryScrollController;

  const ForYou({super.key, required this.primaryScrollController});

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

    _scrollController = widget.primaryScrollController..addListener(_onScroll);
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
              child: Stack(
                children: [
                  ListView.builder(
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
                      final lastUpdatedat =
                          searchResult.articleDetailLink!.updatedAtFormatted;
                      final title = searchResult.title;
                      final likescount =
                          searchResult.articleDetailLink!.likesCount;
                      final viewcount =
                          searchResult.articleDetailLink!.viewsCount;
                      final commentcount =
                          searchResult.articleDetailLink!.commentsCount;
                      final isliked = searchResult.tUserArticleLikesAggregate!
                                  .aggregate!.count ==
                              0
                          ? false
                          : true;
                      final isviewed = searchResult.tUserArticleViewsAggregate!
                                  .aggregate!.count ==
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
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 1000.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Positioned(
                      bottom: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            // Handle button press
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              gradient: const SweepGradient(
                                center: FractionalOffset.center,
                                startAngle: 0.0,
                                endAngle: 3.14 * 2,
                                colors: <Color>[
                                  Color.fromARGB(255, 252, 165, 124),
                                  Color.fromARGB(255, 114, 170, 220),
                                  Color.fromARGB(255, 196, 141, 193),
                                  Color.fromARGB(255, 116, 220, 244),
                                  Color.fromARGB(255, 210, 184, 166),
                                ],
                                stops: <double>[0.0, 0.15, 0.35, 0.65, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 10,
                                  blurRadius: 15,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.play_arrow,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
