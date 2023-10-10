import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/04_home/bloc/articles_rss1_bloc.dart';
import 'package:synopse_v001/features/04_home/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:synopse_v001/features/04_home/ui/widgets/home_error_view.dart';

class ArticlesRss1Feed extends StatefulWidget {
  const ArticlesRss1Feed({Key? key}) : super(key: key);

  @override
  ArticlesRss1FeedState createState() => ArticlesRss1FeedState();
}

class ArticlesRss1FeedState extends State<ArticlesRss1Feed> {
  late final ScrollController _scrollController;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    context.read<ArticlesRss1Bloc>().add(const ArticlesRss1Fetch());
    _scrollController = ScrollController()..addListener(_onScroll);
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      },
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<ArticlesRss1Bloc>().add(const ArticlesRss1Fetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BlocBuilder<ArticlesRss1Bloc, ArticlesRss1State>(
              builder: (context, articlestate) {
                if (articlestate.status == ArticlesRss1Status.initial) {
                  return const Center(
                    child: CustomCircularProgressIndicator(),
                  );
                } else if (articlestate.status == ArticlesRss1Status.success) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<ArticlesRss1Bloc>()
                          .add(const ArticlesRss1Refresh());
                    },
                    child: Column(
                      children: [
                        if (screenSize.width > 1500)
                          Expanded(
                            child: MasonryGridView.builder(
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              controller: _scrollController,
                              itemCount: articlestate.hasReachedMax
                                  ? articlestate
                                      .articlesTV1ArticalsGroupsL1Detail.length
                                  : articlestate
                                          .articlesTV1ArticalsGroupsL1Detail
                                          .length +
                                      1,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: index >=
                                          articlestate
                                              .articlesTV1ArticalsGroupsL1Detail
                                              .length
                                      ? const Center(
                                          child:
                                              CustomCircularProgressIndicator(),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildArticleRss1(
                                                context, articlestate, index),
                                          ],
                                        ),
                                );
                              },
                            ),
                          )
                        else if (screenSize.width > 800)
                          Expanded(
                            child: MasonryGridView.builder(
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              controller: _scrollController,
                              itemCount: articlestate.hasReachedMax
                                  ? articlestate
                                      .articlesTV1ArticalsGroupsL1Detail.length
                                  : articlestate
                                          .articlesTV1ArticalsGroupsL1Detail
                                          .length +
                                      1,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: index >=
                                          articlestate
                                              .articlesTV1ArticalsGroupsL1Detail
                                              .length
                                      ? const Center(
                                          child:
                                              CustomCircularProgressIndicator(),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildArticleRss1(
                                                context, articlestate, index),
                                          ],
                                        ),
                                );
                              },
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: articlestate.hasReachedMax
                                  ? articlestate
                                      .articlesTV1ArticalsGroupsL1Detail.length
                                  : articlestate
                                          .articlesTV1ArticalsGroupsL1Detail
                                          .length +
                                      1,
                              itemBuilder: (context, index) {
                                return index >=
                                        articlestate
                                            .articlesTV1ArticalsGroupsL1Detail
                                            .length
                                    ? const Center(
                                        child:
                                            CustomCircularProgressIndicator(),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildArticleRss1(
                                              context, articlestate, index),
                                        ],
                                      );
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  );
                } else {
                  return const HomeErrorView();
                }
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 50,
              color: Colors.black,
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.push(home);
                    },
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (!isLoggedIn)
                    IconButton(
                      onPressed: () {
                        context.push(login);
                      },
                      icon: const Icon(
                        Icons.app_registration,
                        color: Colors.grey,
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      context.push(user);
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center buildArticleRss1(
      BuildContext context, ArticlesRss1State state, int index) {
    int randomNumber = 0;
    if (index == 0 || index % 3 == 0) {
      randomNumber = 1;
    }
    String formattedDifference;

    final now = DateTime.now().toUtc();
    final postPublished =
        state.articlesTV1ArticalsGroupsL1Detail[index].updatedAt!.toUtc();
    final difference = now.toUtc().difference(postPublished);

    if (difference.inMinutes < 60) {
      formattedDifference = '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      formattedDifference = '${difference.inHours}h';
    } else {
      formattedDifference = '${difference.inDays}d';
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
        ),
        child: Builder(builder: (context) {
          var url = "";
          var likes = state
              .articlesTV1ArticalsGroupsL1Detail[index].articleGroupsL1ToLikes;
          int likesCount = 0;
          if (likes != null) {
            likesCount = likes.likeCount.toInt();
          }
          var views = state
              .articlesTV1ArticalsGroupsL1Detail[index].articleGroupsL1ToViews;
          int viewsCount = 0;
          if (views != null) {
            viewsCount = views.viewCount.toInt();
          }
          var comments = state.articlesTV1ArticalsGroupsL1Detail[index]
              .articleGroupsL1ToComments;
          int commentCount = 0;
          if (comments != null) {
            commentCount = comments.commentCount.toInt();
          }
          var isLikedOrViewed = state.articlesTV1ArticalsGroupsL1Detail[index]
              .tV1ArticalsGroupsL1ViewsLikes;
          bool isliked = false;
          bool isviewed = false;
          if (isLikedOrViewed != []) {
            for (var i in isLikedOrViewed) {
              if (i.type == 1) {
                isliked = true;
              } else if (i.type == 0) {
                isviewed = true;
              }
            }
          }
          return GestureDetector(
            onTap: () {
              if (!isLoggedIn) {
                context.push(login);
              } else if (isLoggedIn) {
                if (isviewed) {}
                context.push(detail,
                    extra: state.articlesTV1ArticalsGroupsL1Detail[index]
                        .articleGroupId);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (randomNumber == 1 &&
                    state.articlesTV1ArticalsGroupsL1Detail[index].imageUrls
                        .isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.constrainWidth(500),
                          height: constraints.constrainWidth(500) * 9 / 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: state
                                  .articlesTV1ArticalsGroupsL1Detail[index]
                                  .imageUrls[0],
                              placeholder: (context, url) =>
                                  const CustomCircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              for (url in state
                                  .articlesTV1ArticalsGroupsL1Detail[index]
                                  .logoUrls)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: url,
                                      placeholder: (context, url) =>
                                          const CustomCircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(formattedDifference,
                                  style: const TextStyle(
                                      fontSize: 8,
                                      fontFamily: 'Roboto condensed',
                                      color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state
                                .articlesTV1ArticalsGroupsL1Detail[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontFamily: 'Roboto condensed',
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (!isLoggedIn)
                                Icon(
                                  Icons.favorite_border,
                                  size: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.5),
                                ),
                              if (isLoggedIn)
                                isliked
                                    ? Icon(
                                        Icons.favorite,
                                        size: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                      ),
                              if (likesCount > 0)
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      state
                                              .articlesTV1ArticalsGroupsL1Detail[
                                                  index]
                                              .articleGroupsL1ToLikes!
                                              .likeCount
                                              .toString() +
                                          " likes",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontFamily: 'Roboto condensed',
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ],
                                ),
                              if (commentCount > 0)
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 2,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      state
                                              .articlesTV1ArticalsGroupsL1Detail[
                                                  index]
                                              .articleGroupsL1ToComments!
                                              .commentCount
                                              .toString() +
                                          " comments",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontFamily: 'Roboto condensed',
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ],
                                ),
                              if (viewsCount > 0)
                                Row(
                                  children: [
                                    const SizedBox(width: 6),
                                    const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 2,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      state
                                              .articlesTV1ArticalsGroupsL1Detail[
                                                  index]
                                              .articleGroupsL1ToViews!
                                              .viewCount
                                              .toString() +
                                          " reads",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontFamily: 'Roboto condensed',
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                    const SizedBox(width: 3),
                                    if (isviewed)
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                            .withOpacity(0.5),
                                      ),
                                  ],
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                    if (randomNumber != 1 &&
                        state.articlesTV1ArticalsGroupsL1Detail[index].imageUrls
                            .isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: state
                                  .articlesTV1ArticalsGroupsL1Detail[index]
                                  .imageUrls[0],
                              placeholder: (context, url) =>
                                  const CustomCircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                Divider(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                  thickness: 0.1,
                ), // draws a gray line
              ],
            ),
          );
        }),
      ),
    );
  }
}
