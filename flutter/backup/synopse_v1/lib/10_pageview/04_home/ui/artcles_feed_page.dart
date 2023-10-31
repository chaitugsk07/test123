import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_carousel.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/07_pageview/04_home/01_model_repo/source_articlerss1page_api.dart';
import 'package:synopse_v001/features/07_pageview/04_home/bloc/articles_rss1_page_bloc.dart';

class ArticleRss1Page extends StatelessWidget {
  const ArticleRss1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArticlesRss1PageBloc>(
          create: (context) => ArticlesRss1PageBloc(
            rssFeedPageView: RssFeedPageView(
              GraphQLService(),
            ),
          )..add(const ArticlesRss1PageFetch()),
        ),
      ],
      child: ArticlePage(),
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
  final _scrollController = ScrollController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ArticlesRss1PageBloc, ArticlesRss1PageState>(
        builder: (context, state) {
          return PageView.builder(
            controller: _controller,
            itemCount: state.articlesTV1ArticalsGroupsL1DetailPage.length,
            scrollDirection: Axis.vertical,
            pageSnapping: true, // enable snap scrolling
            itemBuilder: (context, index) {
              return ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var url in state
                                .articlesTV1ArticalsGroupsL1DetailPage[index]
                                .logoUrls)
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    placeholder: (context, url) =>
                                        const ImageShimmer(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ImageCarousel(
                          imageUrls: state
                              .articlesTV1ArticalsGroupsL1DetailPage[index]
                              .imageUrls,
                          height: 200,
                          aspectRatio: 16 / 9,
                          duration: const Duration(seconds: 2),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.articlesTV1ArticalsGroupsL1DetailPage[index]
                                  .title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontFamily: 'Roboto Condensed',
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
                            state.articlesTV1ArticalsGroupsL1DetailPage[index]
                                .summary60Words,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontFamily: 'Roboto Condensed',
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
            onPageChanged: (index) {
              if (index ==
                  state.articlesTV1ArticalsGroupsL1DetailPage.length - 2) {
                context
                    .read<ArticlesRss1PageBloc>()
                    .add(const ArticlesRss1PageFetch());
              }
            },
          );
        },
      ),
    );
  }
}
