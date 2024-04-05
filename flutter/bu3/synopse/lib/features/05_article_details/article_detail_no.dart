import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api_nologin.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/05_article_details/bloc_article_group_details_no/article_details_no_bloc.dart';
import 'package:synopse/features/05_article_details/widgets/article_ids.dart';

class ArticleDetailSNo extends StatelessWidget {
  final int articleGroupid;
  final int type;

  const ArticleDetailSNo(
      {super.key, required this.articleGroupid, required this.type});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticleDetailsNoBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          )..add(ArticleDetailsNoFetch(articleGrouppId: articleGroupid)),
        ),
      ],
      child: BlocBuilder<ArticleDetailsNoBloc, ArticleDetailsNoState>(
        builder: (context, articleDetailsNoState) {
          if (articleDetailsNoState.status == ArticleDetailsNoStatus.initial) {
            return const Center(
                child: PageLoading(
              title: "Loading Article Details no login",
            ));
          } else if (articleDetailsNoState.status ==
              ArticleDetailsNoStatus.success) {
            final articleDetailsNo = articleDetailsNoState
                .synopseArticlesTV3ArticleGroupsL2[0].tV4ArticleGroupsL2Detail!;
            final articleCount =
                articleDetailsNo.articleDetailLink!.articleCount;
            return ArticleDetail(
              images: articleDetailsNo.imageUrls,
              logoUrls: articleDetailsNo.logoUrls,
              ind: 0,
              articleGroupid: articleGroupid,
              lastUpdatedat:
                  articleDetailsNo.articleDetailLink!.updatedAtFormatted,
              title: articleDetailsNo.title,
              likesCount: articleDetailsNo.articleDetailLink!.likesCount,
              commentsCount: articleDetailsNo.articleDetailLink!.commentsCount,
              viewsCount: articleDetailsNo.articleDetailLink!.viewsCount,
              isLiked: false,
              isViewed: false,
              isCommented: false,
              isbookmarked: false,
              articleCount: articleCount,
              summary: articleDetailsNo.summary,
              aiTagL1: articleDetailsNo.groupAiTagsL1,
              aiTagL2: articleDetailsNo.groupAiTagsL2,
              articleIds: articleDetailsNoState
                  .synopseArticlesTV3ArticleGroupsL2[0].articlesGroup,
              type: type,
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
  final String aiTagL1;
  final String aiTagL2;
  final List<int> articleIds;
  final int type;

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
      required this.aiTagL1,
      required this.aiTagL2,
      required this.articleIds,
      required this.type});

  @override
  State<ArticleDetail> createState() => _ArticleDetailSNotate();
}

class _ArticleDetailSNotate extends State<ArticleDetail> {
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likesCount;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isBookmarked = widget.isbookmarked;
    _likesCount = widget.likesCount;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    context
        .read<ArticleDetailsNoBloc>()
        .add(ArticleDetailsNoFetch(articleGrouppId: widget.articleGroupid));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    width = width.roundToDouble();
    if (width % 2 != 0) {
      // if height is not even
      width += 1; // make it even by adding 1
    }
    double height = width * 9 / 16;
    height = width * 9 / 16;
    if (height > 300) {
      height = 300;
    }
    if (widget.images.isEmpty) {
      height = 0;
    }
    String summary = widget.summary;
    List<String> lines = summary.split('\n');
    lines = lines.map((line) => line.trim()).toList();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: ((context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    foregroundColor: Theme.of(context).colorScheme.onBackground,
                    scrolledUnderElevation: 0.0,
                    centerTitle: true,
                    elevation: 0.0,
                    expandedHeight: height,
                    flexibleSpace: Stack(
                      children: [
                        if (widget.images.isNotEmpty && !innerBoxIsScrolled)
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 450.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: ImageCaresole(
                                width: width,
                                height: height,
                                rounded: 0.0,
                                images: widget.images,
                                type: 3),
                          ),
                        Positioned(
                          top: height - 60,
                          left: 0,
                          child: Container(
                            width: width,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 10,
                                  blurRadius: 15,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: Text(
                          widget.title.trim(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ];
              }),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 30,
                          constraints: BoxConstraints(
                            maxWidth: width - 80,
                          ),
                          child: ListView.builder(
                            itemCount: widget.logoUrls.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ClipOval(
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 25,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.logoUrls[index],
                                        placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              height: 25,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Animate(
                            effects: [
                              FadeEffect(
                                  delay: 450.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Text(
                              lines.join('\n'),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.1),
                          child: Column(
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
                                    'Sources Used',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                              ArticleIdS(articleIds: widget.articleIds),
                            ],
                          ),
                        ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 550.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'AI-Powered summary, which may contain mistakes. To verify accuracy, please visit the source articles.',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.5),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext context,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return AlertDialog(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              shadowColor:
                                  Theme.of(context).colorScheme.background,
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              content: SizedBox(
                                height: 350,
                                width: 400,
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10),
                                    child: Icon(
                                      Icons.lock,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Unlock to access all Synopse AI features",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: SizedBox(
                                      width: 300,
                                      child: Text(
                                        "To get the most of Synopse experience, login and unlock the world of personalized AI features.",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 200.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push(signUp);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 40,
                                        width: 200,
                                        child: Text(
                                          "Login",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 200.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: GestureDetector(
                                      onTap: () {
                                        context.pop();
                                      },
                                      child: Center(
                                        child: SizedBox(
                                          width: 200,
                                          height: 50,
                                          child: Text(
                                            "Continue as Guest",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 10,
                              blurRadius: 15,
                              offset: const Offset(
                                  0, -3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 120,
                        width: width,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50, // Adjust the height as needed
                              child: Center(
                                child: SizedBox(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background
                                          .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.handSparkles,
                                          size: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Ask Follow Up Questions",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.5),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Animate(
                              effects: [
                                SlideEffect(
                                  begin: const Offset(0, 1),
                                  end: const Offset(0, 0),
                                  delay: 100.microseconds,
                                  duration: 1000.milliseconds,
                                  curve: Curves.easeInOutCubic,
                                ),
                              ],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.5),
                                        size: 25,
                                      ),
                                      if (_likesCount > 0)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            '$_likesCount Likes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.5),
                                                ),
                                          ),
                                        ),
                                      if (_likesCount == 0)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            '0 Likes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.5),
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 400.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.5),
                                            size: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              'Save For Later',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground
                                                        .withOpacity(0.5),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 20, right: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.type == 1) {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.push(home);
                        }
                      } else {
                        context.push(home);
                      }
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(150),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.push(
                        articleShare,
                        extra: ArticleShareData(
                          tag: widget.aiTagL2,
                          title: widget.title,
                          description: widget.summary,
                          reads: widget.viewsCount,
                          imageurl:
                              widget.images.isEmpty ? "na" : widget.images[0],
                          articleGroupId: widget.articleGroupid,
                        ),
                      );
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(150),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.share,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
