import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/15_article_publisher/bloc_get_all_publisher/get_all_publisher_bloc.dart';

class ArticlesPub111 extends StatelessWidget {
  final int outletId;
  final String outletName;
  final String outletUrl;

  const ArticlesPub111(
      {super.key,
      required this.outletId,
      required this.outletName,
      required this.outletUrl});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllPublisherBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ArticlePub1(
        outletId: outletId,
        outletName: outletName,
        outletUrl: outletUrl,
      ),
    );
  }
}

class ArticlePub1 extends StatefulWidget {
  final int outletId;
  final String outletName;
  final String outletUrl;

  const ArticlePub1(
      {super.key,
      required this.outletId,
      required this.outletName,
      required this.outletUrl});

  @override
  State<ArticlePub1> createState() => _ArticlePub1State();
}

class _ArticlePub1State extends State<ArticlePub1> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<GetAllPublisherBloc>().add(
          GetAllPublisherFetch(outletId: widget.outletId),
        );
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<GetAllPublisherBloc>().add(
            GetAllPublisherFetch(outletId: widget.outletId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllPublisherBloc, GetAllPublisherState>(
        builder: (context, getAllPublisherState) {
      if (getAllPublisherState.status == GetAllPublisherStatus.initial) {
        return const Center(
          child: PageLoading(
            title: "Article Publisher",
          ),
        );
      } else if (getAllPublisherState.status == GetAllPublisherStatus.success) {
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount:
                getAllPublisherState.synopseArticlesTV1Rss1ArticleF1.length,
            itemBuilder: (context, index) {
              final art1 =
                  getAllPublisherState.synopseArticlesTV1Rss1ArticleF1[index];
              return GestureDetector(
                onTap: () {
                  context.push(detailpage, extra: art1.postLink);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 150.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Row(
                          children: [
                            SizedBox(
                              height: 15,
                              child: CachedNetworkImage(
                                imageUrl: widget.outletUrl,
                                placeholder: (context, url) => Center(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.outletName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              art1.tArticleMeta!.updatedAtFormatted,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (art1.imageLink == "")
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 250.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Text(
                            art1.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      if (art1.imageLink != "")
                        Row(
                          children: [
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 250.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Expanded(
                                child: Text(
                                  art1.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 75 * 9 / 16,
                              width: 75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: art1.imageLink,
                                  placeholder: (context, url) => Center(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 75 * 9 / 16,
                                        width: 75,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
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
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
