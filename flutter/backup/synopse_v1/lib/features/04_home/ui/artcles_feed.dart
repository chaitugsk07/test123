import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
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
      context.read<ArticlesRss1Bloc>().add(const ArticlesRss1Fetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Center(
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
                              ? articlestate.articlesVArticleGroup.length
                              : articlestate.articlesVArticleGroup.length + 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: index >=
                                      articlestate.articlesVArticleGroup.length
                                  ? const Center(
                                      child: CustomCircularProgressIndicator(),
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
                              ? articlestate.articlesVArticleGroup.length
                              : articlestate.articlesVArticleGroup.length + 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: index >=
                                      articlestate.articlesVArticleGroup.length
                                  ? const Center(
                                      child: CustomCircularProgressIndicator(),
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
                              ? articlestate.articlesVArticleGroup.length
                              : articlestate.articlesVArticleGroup.length + 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: index >=
                                      articlestate.articlesVArticleGroup.length
                                  ? const Center(
                                      child: CustomCircularProgressIndicator(),
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
                      ),
                  ],
                ),
              );
            } else {
              return const HomeErrorView();
            }
          },
        ),
      ),
    );
  }

  Center buildArticleRss1(
      BuildContext context, ArticlesRss1State state, int index) {
    //print(state.articlesVArticleGroup[index].title);
    final random = Random();
    const min = 1;
    const max = 5;
    final randomNumber = min + random.nextInt(max - min);
    String formattedDifference;

    final now = DateTime.now().toUtc();
    final postPublished = state.articlesVArticleGroup[index].updatedAt!.toUtc();
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (randomNumber == 1 &&
                  state.articlesVArticleGroup[index].imageUrls.isNotEmpty)
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
                            imageUrl:
                                state.articlesVArticleGroup[index].imageUrls[0],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
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
                            for (url
                                in state.articlesVArticleGroup[index].logoUrls)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
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
                          state.articlesVArticleGroup[index].title,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontFamily: 'Roboto condensed',
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                bool isLoggedIn =
                                    prefs.getBool('isLoggedIn') ?? false;
                                if (!isLoggedIn) {
                                  context.push(login);
                                }
                              },
                              child: Icon(
                                Icons.favorite_border,
                                size: 15,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.5),
                              ),
                            ),
                            if (state.articlesVArticleGroup[index].likeCount >
                                0)
                              Row(
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    state.articlesVArticleGroup[index].likeCount
                                        .toString(),
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
                            if (state
                                    .articlesVArticleGroup[index].commentCount >
                                0)
                              Row(
                                children: [
                                  const SizedBox(width: 4),
                                  const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 2,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    state.articlesVArticleGroup[index]
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
                            if (state.articlesVArticleGroup[index].viewCount >
                                0)
                              Row(
                                children: [
                                  const SizedBox(width: 6),
                                  const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 2,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    state.articlesVArticleGroup[index].viewCount
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
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (randomNumber != 1 &&
                      state.articlesVArticleGroup[index].imageUrls.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                state.articlesVArticleGroup[index].imageUrls[0],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
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
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                thickness: 0.1,
              ), // draws a gray line
            ],
          );
        }),
      ),
    );
  }
}
