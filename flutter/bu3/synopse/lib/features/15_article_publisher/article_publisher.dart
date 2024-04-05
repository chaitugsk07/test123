import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/15_article_publisher/bloc_article_publisher_main_follow/article_publisher_main_bloc.dart';
import 'package:synopse/features/15_article_publisher/bloc_get_all_publisher/get_all_publisher_bloc.dart';
import 'package:synopse/features/15_article_publisher/widgets/articles_pub1.dart';

class ArticlePublishers111 extends StatelessWidget {
  final String logoUrl;

  const ArticlePublishers111({super.key, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticlePublisherMainBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetAllPublisherBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ArtilePublishers11(
        logoUrl: logoUrl,
      ),
    );
  }
}

class ArtilePublishers11 extends StatefulWidget {
  final String logoUrl;

  const ArtilePublishers11({super.key, required this.logoUrl});

  @override
  State<ArtilePublishers11> createState() => _ArtilePublishers11State();
}

class _ArtilePublishers11State extends State<ArtilePublishers11> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlePublisherMainBloc>().add(
          ArticlePublisherMainFetch(logoUrl: widget.logoUrl),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Publisher",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body:
              BlocBuilder<ArticlePublisherMainBloc, ArticlePublisherMainState>(
            builder: (context, articlePublisherMainState) {
              if (articlePublisherMainState.status ==
                  ArticlePublisherMainStatus.initial) {
                return const Center(
                  child: PageLoading(
                    title: "Article Publisher",
                  ),
                );
              } else if (articlePublisherMainState.status ==
                  ArticlePublisherMainStatus.success) {
                final publishMain =
                    articlePublisherMainState.synopseArticlesTV1Outlet[0];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 150.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: CachedNetworkImage(
                          imageUrl: widget.logoUrl,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 25,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) => Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 25,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 250.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            publishMain.outletDisplay,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                      if (publishMain.outletDescription != "")
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 250.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              publishMain.outletDescription,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 350.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                          thickness: 0.7,
                        ),
                      ),
                      ArticlesPub111(
                        outletId: publishMain.outletId,
                        outletName: publishMain.outletDisplay,
                        outletUrl: widget.logoUrl,
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
