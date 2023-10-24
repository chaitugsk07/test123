import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/article_tile_build1.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/home_error_view.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_carousel.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/loading_effect.dart';
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
          ),
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
  int commentsCount = 0;
  num likeCount = 0;
  @override
  void initState() {
    super.initState();
    context
        .read<ArticlesDetailBloc>()
        .add(ArticlesDetailFetch(articleGroupId: widget.articleDetailId));
    final articlesDetailBloc = BlocProvider.of<ArticlesDetailBloc>(context);
    articlesDetailBloc.stream.listen(
      (state) {
        if (state.status == ArticlesRss1StatusDetail.success) {
          commentsCount = state.articlesVArticlesMain[0].commentsCount.toInt();
          var likes = state.articlesVArticlesMain[0].articlesLikes;
          if (likes != null) {
            isliked = true;
            likeCount = state.articlesVArticlesMain[0].likesCount + 1;
          } else {
            isliked = false;
            likeCount = state.articlesVArticlesMain[0].likesCount;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesDetailBloc, ArticleDetailState>(
        builder: (context, articleDetailState) {
      if (articleDetailState.status == ArticlesRss1StatusDetail.initial) {
        return const PageLoading();
      }
      if (articleDetailState.status == ArticlesRss1StatusDetail.success) {
        final bloc = context.read<ArticlesOriginalBloc>();
        bloc.add(ArticlesOriginalFetch(
            articleIds: articleDetailState
                .articlesVArticlesMain[0].articleToGroup!.articlesGroup));
        return Scaffold(
          appBar: AppBar(
            leading: Animate(
              effects: [
                FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
              ],
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
            actions: [
              const Spacer(),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 250,
                child: Center(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: articleDetailState
                        .articlesVArticlesMain[0].logoUrls.length,
                    itemBuilder: (context, index) {
                      final url = articleDetailState
                          .articlesVArticlesMain[0].logoUrls[index];

                      return Animate(
                        effects: [
                          FadeEffect(
                              delay: 200.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              placeholder: (context, url) =>
                                  const ImageShimmer(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              Animate(
                effects: [
                  FadeEffect(
                      delay: 250.milliseconds, duration: 1000.milliseconds)
                ],
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.bookmark_border_outlined,
                  ),
                ),
              ),
              Animate(
                effects: [
                  FadeEffect(
                      delay: 250.milliseconds, duration: 1000.milliseconds)
                ],
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.article,
                  ),
                ),
              ),
              Animate(
                effects: [
                  FadeEffect(
                      delay: 300.milliseconds, duration: 1000.milliseconds)
                ],
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Animate(
            effects: [
              SlideEffect(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
                delay: 100.microseconds,
                duration: 1000.milliseconds,
                curve: Curves.easeInOutCubic,
              ),
            ],
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Theme.of(context).colorScheme.onBackground,
                unselectedItemColor: Theme.of(context).colorScheme.onBackground,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: 4,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      context.push(comments,
                          extra: articleDetailState
                              .articlesVArticlesMain[index].articleGroupId);
                      break;
                    case 1:
                      setState(() {
                        final bloc = context.read<SetLikeViewCommentBloc>();
                        if (isliked) {
                          likeCount = likeCount - 1;

                          bloc.add(SetLikeViewCommentEventSetLike(
                              action: 'DeleteLike',
                              articleGroupId: widget.articleDetailId));
                        } else {
                          bloc.add(SetLikeViewCommentEventSetLike(
                              action: 'InsertLike',
                              articleGroupId: widget.articleDetailId));
                          likeCount = likeCount + 1;
                        }
                        isliked = !isliked;
                      });
                      break;
                    case 2:
                      // handle onPressed for third icon
                      break;
                    case 3:
                      // handle onPressed for fourth icon
                      break;
                    case 4:
                      break;
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Animate(
                      effects: [
                        FadeEffect(
                            delay: 200.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.message,
                            size: 20,
                          ),
                          if (commentsCount != 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                commentsCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Animate(
                      effects: [
                        FadeEffect(
                            delay: 300.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isliked
                              ? const FaIcon(
                                  FontAwesomeIcons.solidHeart,
                                  size: 20,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: 20,
                                ),
                          if (likeCount != 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                likeCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontSize: 18),
                              ),
                            )
                        ],
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Animate(
                      effects: [
                        FadeEffect(
                            delay: 300.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: const FaIcon(
                        FontAwesomeIcons.textSlash,
                        size: 15,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Animate(
                      effects: [
                        FadeEffect(
                            delay: 400.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: const FaIcon(
                        FontAwesomeIcons.video,
                        size: 15,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Animate(
                      effects: [
                        FadeEffect(
                            delay: 500.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: const FaIcon(
                        FontAwesomeIcons.userSecret,
                        size: 15,
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Animate(
                  effects: [
                    FadeEffect(
                        delay: 200.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      articleDetailState.articlesVArticlesMain[0].title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Animate(
                effects: [
                  FadeEffect(
                      delay: 200.milliseconds, duration: 1000.milliseconds)
                ],
                child: ImageCarousel(
                  imageUrls:
                      articleDetailState.articlesVArticlesMain[0].imageUrls,
                  height: 200,
                  aspectRatio: 16 / 9,
                  duration: const Duration(seconds: 2),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Animate(
                effects: [
                  FadeEffect(
                      delay: 300.milliseconds, duration: 1000.milliseconds)
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    textAlign: TextAlign.start,
                    articleDetailState.articlesVArticlesMain[0].summary,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 15, height: 1.5, wordSpacing: 2),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<ArticlesOriginalBloc,
                              ArticlesOriginalState>(
                          builder: (context, articlesOriginalState) {
                        if (articlesOriginalState.status ==
                            ArticlesOriginalStatus.initial) {
                          return const CircularProgressIndicator();
                        } else if (articlesOriginalState.status ==
                            ArticlesOriginalStatus.success) {
                          return SizedBox(
                            height: articlesOriginalState
                                    .articlesTV1Rss1Artical.length *
                                100,
                            child: Builder(builder: (context) {
                              return ListView.builder(
                                itemCount: articlesOriginalState
                                    .articlesTV1Rss1Artical.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildArticle1(
                                        state: articlesOriginalState,
                                        index: index,
                                        isLoggedIn: true,
                                        buildType: "feed",
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      } else {
        return const HomeErrorView();
      }
    });
  }
}
