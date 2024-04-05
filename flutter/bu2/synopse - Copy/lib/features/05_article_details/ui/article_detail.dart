import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/article_details_tags.dart';
import 'package:synopse/features/00_common_widgets/article_ids.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/05_article_details/bloc/article_group_details/article_details_bloc.dart';

class ArticleDetailS extends StatelessWidget {
  final int articleGroupid;

  const ArticleDetailS({super.key, required this.articleGroupid});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticleDetailsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          )..add(ArticleDetailsFetch(articleGrouppId: articleGroupid)),
        ),
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ArticleDetailsBloc, ArticleDetailsState>(
        builder: (context, articleDetailsState) {
          if (articleDetailsState.status == ArticleDetailsStatus.initial) {
            return const Center(child: PageLoading());
          } else if (articleDetailsState.status ==
              ArticleDetailsStatus.success) {
            final articleDetails = articleDetailsState
                .synopseArticlesTV3ArticleGroupsL2[0].tV4ArticleGroupsL2Detail!;
            final isliked =
                articleDetails.tUserArticleLikesAggregate!.aggregate!.count == 0
                    ? false
                    : true;
            final isviewed =
                articleDetails.tUserArticleViewsAggregate!.aggregate!.count == 0
                    ? false
                    : true;
            final iscommented = articleDetails
                        .tUserArticleCommentsAggregate!.aggregate!.count ==
                    0
                ? false
                : true;
            final isbookmarked = articleDetails
                        .tUserArticleBookmarksAggregate!.aggregate!.count ==
                    0
                ? false
                : true;
            final articleCount = articleDetails.articleDetailLink!.articleCount;
            return ArticleDetail(
              images: articleDetails.imageUrls,
              logoUrls: articleDetails.logoUrls,
              ind: 0,
              articleGroupid: articleGroupid,
              lastUpdatedat:
                  articleDetails.articleDetailLink!.updatedAtFormatted,
              title: articleDetails.title,
              likesCount: articleDetails.articleDetailLink!.likesCount,
              commentsCount: articleDetails.articleDetailLink!.commentsCount,
              viewsCount: articleDetails.articleDetailLink!.viewsCount,
              isLiked: isliked,
              isViewed: isviewed,
              isCommented: iscommented,
              isbookmarked: isbookmarked,
              articleCount: articleCount,
              summary: articleDetails.summary,
              aiTags: articleDetails.aiTags,
              articleIds: articleDetailsState
                  .synopseArticlesTV3ArticleGroupsL2[0].articlesGroup,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ArticleDetail extends StatefulWidget {
  final List<String> images;
  final List<String> logoUrls;
  final int ind;
  final int articleGroupid;
  final String lastUpdatedat;
  final String title;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final bool isLiked;
  final bool isViewed;
  final bool isCommented;
  final bool isbookmarked;
  final int articleCount;
  final String summary;
  final List<String> aiTags;
  final List<int> articleIds;

  const ArticleDetail(
      {super.key,
      required this.images,
      required this.logoUrls,
      required this.ind,
      required this.articleGroupid,
      required this.lastUpdatedat,
      required this.title,
      required this.likesCount,
      required this.commentsCount,
      required this.viewsCount,
      required this.isLiked,
      required this.isViewed,
      required this.isCommented,
      required this.isbookmarked,
      required this.articleCount,
      required this.summary,
      required this.aiTags,
      required this.articleIds});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isBookmarked = widget.isbookmarked;
    _likesCount = widget.likesCount;
    context
        .read<ArticleDetailsBloc>()
        .add(ArticleDetailsFetch(articleGrouppId: widget.articleGroupid));
    if (!widget.isViewed) {
      context.read<UserEventBloc>().add(
            UserEventView(articleGrouppId: widget.articleGroupid),
          );
    }
  }

  Future<void> share(String title, String articleGroupId) async {
    final result = await Share.shareWithResult(
        ' $title \n https://synopse-ai.web.app/dd/$articleGroupId'
        '\n -via Synopse AI');

    if (result.status == ShareResultStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "The Article is shared successfully",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 600,
          ),
          child: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 50,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 200.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: IconButton(
                                  onPressed: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.push(splash);
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back_ios),
                                ),
                              ),
                              Container(
                                height: 30,
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 200,
                                ),
                                child: ListView.builder(
                                  itemCount: widget.logoUrls.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ClipOval(
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          return Animate(
                                            effects: [
                                              FadeEffect(
                                                  delay: 350.milliseconds,
                                                  duration: 1000.milliseconds)
                                            ],
                                            child: GestureDetector(
                                              onTap: () {
                                                context.push(mainPublisher,
                                                    extra:
                                                        widget.logoUrls[index]);
                                              },
                                              child: SizedBox(
                                                height: 15,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      widget.logoUrls[index],
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Spacer(),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 400.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: GestureDetector(
                                  onTap: () {
                                    setState(
                                      () {
                                        if (_isBookmarked) {
                                          context.read<UserEventBloc>().add(
                                                UserEventBookmarkDelete(
                                                    articleGrouppId:
                                                        widget.articleGroupid),
                                              );
                                        } else {
                                          context.read<UserEventBloc>().add(
                                                UserEventBookmark(
                                                    articleGrouppId:
                                                        widget.articleGroupid),
                                              );
                                        }
                                        _isBookmarked = !_isBookmarked;
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Icon(
                                      _isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 165,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (widget.images.isNotEmpty)
                                  Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 450.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ImageCaresole(
                                        width: width,
                                        images: widget.images,
                                      ),
                                    ),
                                  ),
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 550.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        widget.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Animate(
                                      effects: [
                                        FadeEffect(
                                            delay: 550.milliseconds,
                                            duration: 1000.milliseconds)
                                      ],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          widget.summary,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ),
                                    ArticleTags(
                                        tags: widget.aiTags, title: "AI Tags"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Animate(
                                      effects: [
                                        FadeEffect(
                                            delay: 550.milliseconds,
                                            duration: 1000.milliseconds)
                                      ],
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'The above article and title was generated by AI',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Animate(
                                      effects: [
                                        FadeEffect(
                                            delay: 600.milliseconds,
                                            duration: 1000.milliseconds)
                                      ],
                                      child: Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.5),
                                        thickness: 0.4,
                                      ),
                                    ),
                                    Animate(
                                      effects: [
                                        FadeEffect(
                                            delay: 550.milliseconds,
                                            duration: 1000.milliseconds)
                                      ],
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Sources Used',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    ArticleIdS(articleIds: widget.articleIds),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Animate(
                      effects: [
                        SlideEffect(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                          delay: 100.microseconds,
                          duration: 1000.milliseconds,
                          curve: Curves.easeInOutCubic,
                        ),
                      ],
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    if (_isLiked) {
                                      context.read<UserEventBloc>().add(
                                            UserEventLikeDelete(
                                                articleGrouppId:
                                                    widget.articleGroupid),
                                          );
                                      _likesCount--;
                                    } else {
                                      context.read<UserEventBloc>().add(
                                            UserEventLike(
                                                articleGrouppId:
                                                    widget.articleGroupid),
                                          );
                                      _likesCount++;
                                    }
                                    _isLiked = !_isLiked;
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    _isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    size: 25,
                                  ),
                                  if (_likesCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Text(
                                        '$_likesCount',
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.push(comments,
                                        extra: widget.articleGroupid);
                                  },
                                  icon: Icon(
                                    widget.isCommented
                                        ? Icons.messenger
                                        : Icons.messenger_outline,
                                  ),
                                ),
                                if (widget.commentsCount > 0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      '${widget.commentsCount}',
                                    ),
                                  ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                share(widget.title,
                                    widget.articleGroupid.toString());
                              },
                              icon: Icon(
                                Icons.share,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
