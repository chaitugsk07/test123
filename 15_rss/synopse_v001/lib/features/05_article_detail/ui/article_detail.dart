import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/04_home/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:synopse_v001/features/04_home/ui/widgets/image_carousel.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/source_articlerss1_api.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/article_original_feed/articles_original_bloc.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/articles_detail_rss1_bloc.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/set_like_view_comment/set_like_view_comment_bloc.dart';

class ArticleDetail extends StatelessWidget {
  final int articleDetailId;
  const ArticleDetail({Key? key, required this.articleDetailId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArticlesDetailBloc>(
          create: (context) => ArticlesDetailBloc(
            rssFeedServicesFeedDetails: RssFeedServicesFeedDetails(
              GraphQLService(),
            ),
          )..add(ArticlesDetailFetch(articleGroupId: articleDetailId)),
        ),
        BlocProvider<ArticlesOriginalBloc>(
          create: (context) => ArticlesOriginalBloc(
            rssFeedServicesFeedDetails: RssFeedServicesFeedDetails(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ArticleDetails(articleDetailId: articleDetailId),
    );
  }
}

class ArticleDetails extends StatefulWidget {
  final int articleDetailId;
  const ArticleDetails({Key? key, required this.articleDetailId})
      : super(key: key);

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  bool isliked = false;
  bool isviewed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 45,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ArticlesDetailBloc, ArticleDetailState>(
                  builder: (context, articleDetailState) {
                    if (articleDetailState.status ==
                        ArticlesRss1StatusDetail.initial) {
                      return const Center(
                        child: CustomCircularProgressIndicator(),
                      );
                    } else if (articleDetailState.status ==
                        ArticlesRss1StatusDetail.success) {
                      final bloc = context.read<ArticlesOriginalBloc>();
                      bloc.add(ArticlesOriginalFetch(
                          articleIds: articleDetailState
                              .articlesTV1ArticalsGroupsL1DetailSummary[0]
                              .tV1ArticalsGroupsL1!
                              .articlesGroup));
                      var isLikedOrViewed = articleDetailState
                          .articlesTV1ArticalsGroupsL1DetailSummary[0]
                          .tV1ArticalsGroupsL1ViewsLikes;

                      if (isLikedOrViewed != []) {
                        for (var i in isLikedOrViewed) {
                          if (i.type == 1) {
                            isliked = true;
                          } else if (i.type == 0) {
                            isviewed = true;
                          }
                        }
                      }
                      if (!isviewed) {
                        final bloc1 = context.read<SetLikeViewCommentBloc>();
                        bloc1.add(SetLikeViewCommentEventSetLike(
                            action: 'InsertView',
                            articleGroupId: articleDetailState
                                .articlesTV1ArticalsGroupsL1DetailSummary[0]
                                .articleGroupId));
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              for (var url in articleDetailState
                                  .articlesTV1ArticalsGroupsL1DetailSummary[0]
                                  .logoUrls)
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
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
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              articleDetailState
                                  .articlesTV1ArticalsGroupsL1DetailSummary[0]
                                  .title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontFamily: 'Roboto Condensed'),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ImageCarousel(
                            imageUrls: articleDetailState
                                .articlesTV1ArticalsGroupsL1DetailSummary[0]
                                .imageUrls,
                            height: 200,
                            aspectRatio: 16 / 9,
                            duration: const Duration(seconds: 2),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            articleDetailState
                                .articlesTV1ArticalsGroupsL1DetailSummary[0]
                                .summary,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontFamily: 'Roboto Condensed'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          BlocBuilder<ArticlesOriginalBloc,
                              ArticlesOriginalState>(
                            builder: (context, articlesOriginalState) {
                              if (articlesOriginalState.status ==
                                  ArticlesOriginalStatus.initial) {
                                return const CustomCircularProgressIndicator();
                              } else if (articlesOriginalState.status ==
                                  ArticlesOriginalStatus.success) {
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(
                                      minWidth: 300,
                                      maxWidth: 600,
                                      minHeight: 100,
                                      maxHeight: 300,
                                    ),
                                    child: Builder(builder: (context) {
                                      return ListView.builder(
                                        itemCount: articlesOriginalState
                                            .articlesTV1Rss1Artical.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final article = articlesOriginalState
                                              .articlesTV1Rss1Artical[index];
                                          String formattedDifference;

                                          final now = DateTime.now().toUtc();
                                          final postPublished =
                                              articlesOriginalState
                                                  .articlesTV1Rss1Artical[index]
                                                  .postPublished!
                                                  .toUtc();
                                          final difference = now
                                              .toUtc()
                                              .difference(postPublished);

                                          if (difference.inMinutes < 60) {
                                            formattedDifference =
                                                '${difference.inMinutes}m';
                                          } else if (difference.inHours < 24) {
                                            formattedDifference =
                                                '${difference.inHours}h';
                                          } else {
                                            formattedDifference =
                                                '${difference.inDays}d';
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: article
                                                                        .tV1Rss1FeedLink!
                                                                        .tV1Outlet!
                                                                        .logoUrl,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const CustomCircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                article
                                                                    .tV1Rss1FeedLink!
                                                                    .tV1Outlet!
                                                                    .outletDisplay,
                                                                style: const TextStyle(
                                                                    fontSize: 8,
                                                                    fontFamily:
                                                                        'Roboto condensed',
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                  formattedDifference,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      fontFamily:
                                                                          'Roboto condensed',
                                                                      color: Colors
                                                                          .grey)),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            article.title,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontFamily:
                                                                        'Roboto Condensed'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    if (article
                                                        .imageLink.isNotEmpty)
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: article
                                                                .imageLink,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CustomCircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary
                                                      .withOpacity(0.5),
                                                  thickness: 0.1,
                                                ), // draws a gray line
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ),
                                );
                              } else {
                                return const Text("Error");
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
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
                  if (!isliked)
                    IconButton(
                      onPressed: () {
                        final bloc = context.read<SetLikeViewCommentBloc>();
                        bloc.add(SetLikeViewCommentEventSetLike(
                            action: 'InsertLike',
                            articleGroupId: widget.articleDetailId));
                        setState(() {
                          isliked = true;
                        });
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  if (isliked)
                    IconButton(
                      onPressed: () {
                        final bloc = context.read<SetLikeViewCommentBloc>();
                        bloc.add(SetLikeViewCommentEventSetLike(
                            action: 'DeleteLike',
                            articleGroupId: widget.articleDetailId));
                        setState(() {
                          isliked = false;
                        });
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    ),
                  const Spacer(),
                  //icon button for comments
                  IconButton(
                    onPressed: () {
                      _showComments();
                    },
                    icon: const Icon(
                      Icons.comment,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
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

  void _showComments() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text("absd"),
                      );
                    },
                  ),
                ),
              ],
            )),
          );
        });
  }
}
