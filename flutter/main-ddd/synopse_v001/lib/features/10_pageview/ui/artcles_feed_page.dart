import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/feed_bottom_navigation.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_carousel.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/loading_effect.dart';
import 'package:synopse_v001/features/06_comments/ui/widgets/comments_scaffold.dart';
import 'package:synopse_v001/features/10_pageview/01_model_repo/source_articlerss1page_api.dart';
import 'package:synopse_v001/features/10_pageview/bloc/articles_short_bloc.dart';

class ArticleRss1Page extends StatelessWidget {
  const ArticleRss1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArticleShortBloc>(
          create: (context) => ArticleShortBloc(
            rssFeedPageView: RssFeedPageView(
              GraphQLService(),
            ),
          )..add(const ArticleShortFetch()),
        ),
      ],
      child: const ArticlePage(),
    );
  }
}

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const FeedBottomNavigationMenu(
          isLoggedIn: true,
          iconPos: 2,
        ),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: Animate(
            effects: [
              FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
            ],
            child: IconButton(
              onPressed: () {
                context.push(home);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
          title: Center(
            child: Animate(
              effects: [
                FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
              ],
              child: Text(
                "Shorts",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 20),
              ),
            ),
          ),
          actions: [
            Animate(
              effects: [
                FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
              ],
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_rounded,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ArticleShortBloc, ArticleShortState>(
          builder: (context, articleShortState) {
            if (articleShortState.status == ArticleShortStatus.initial) {
              return const PageLoading();
            } else if (articleShortState.status == ArticleShortStatus.success) {
              return PageView.builder(
                controller: _controller,
                scrollDirection: Axis.vertical,
                pageSnapping: true, // enable snap scrolling
                itemCount: articleShortState.articlesVArticlesMain.length,
                onPageChanged: (index) {
                  if (index ==
                      articleShortState.articlesVArticlesMain.length - 2) {
                    context
                        .read<ArticleShortBloc>()
                        .add(const ArticleShortFetch());
                  }
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    itemCount: articleShortState
                                        .articlesVArticlesMain[index]
                                        .logoUrls
                                        .length,
                                    itemBuilder: (context, itemIndex) {
                                      var url = articleShortState
                                          .articlesVArticlesMain[index]
                                          .logoUrls[itemIndex];
                                      return SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: CachedNetworkImage(
                                            imageUrl: url,
                                            placeholder: (context, url) =>
                                                const ImageShimmer(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ImageCarousel(
                                  imageUrls: articleShortState
                                      .articlesVArticlesMain[index].imageUrls,
                                  height: 150,
                                  aspectRatio: 16 / 9,
                                  duration: const Duration(seconds: 2),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 320,
                            child: SingleChildScrollView(
                              child: GestureDetector(
                                onTap: () {
                                  context.push(detail,
                                      extra: articleShortState
                                          .articlesVArticlesMain[index]
                                          .articleGroupId);
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          softWrap: true,
                                          articleShortState
                                              .articlesVArticlesMain[index]
                                              .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Roboto Condensed',
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        articleShortState
                                            .articlesVArticlesMain[index]
                                            .summary60Words,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontFamily: 'Roboto Condensed',
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
