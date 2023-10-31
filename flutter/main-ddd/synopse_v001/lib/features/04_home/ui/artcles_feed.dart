import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/article_tile_build.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/feed_bottom_navigation.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/home_error_view.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/loading_effect.dart';
import 'package:synopse_v001/features/04_home/bloc/articles_rss1_bloc.dart';

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
      bottomNavigationBar: FeedBottomNavigationMenu(
        isLoggedIn: isLoggedIn,
        iconPos: 0,
      ),
      body: Center(
        child: BlocBuilder<ArticlesRss1Bloc, ArticlesRss1State>(
          builder: (context, articlestate) {
            if (articlestate.status == ArticlesRss1Status.initial) {
              return const PageLoading();
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
                              ? articlestate.articlesVArticlesMain.length
                              : articlestate.articlesVArticlesMain.length + 1,
                          itemBuilder: (context, index) {
                            return index >=
                                    articlestate.articlesVArticlesMain.length
                                ? const ImageShimmer()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildArticle(
                                        state: articlestate,
                                        index: index,
                                        isLoggedIn: isLoggedIn,
                                        buildType: "feed",
                                      ),
                                    ],
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
                              ? articlestate.articlesVArticlesMain.length
                              : articlestate.articlesVArticlesMain.length + 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: index >=
                                      articlestate.articlesVArticlesMain.length
                                  ? const ImageShimmer()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildArticle(
                                          state: articlestate,
                                          index: index,
                                          isLoggedIn: isLoggedIn,
                                          buildType: "feed",
                                        ),
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
                              ? articlestate.articlesVArticlesMain.length
                              : articlestate.articlesVArticlesMain.length + 1,
                          itemBuilder: (context, index) {
                            return index >=
                                    articlestate.articlesVArticlesMain.length
                                ? const ImageShimmer()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildArticle(
                                        state: articlestate,
                                        index: index,
                                        isLoggedIn: isLoggedIn,
                                        buildType: "feed",
                                      ),
                                    ],
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
}
