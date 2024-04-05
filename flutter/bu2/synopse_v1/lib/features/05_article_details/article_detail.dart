import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/05_article_details/bloc_article_group_details/article_details_bloc.dart';
import 'package:synopse/features/05_article_details/widgets/article_ids.dart';

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
              aiTagL1: articleDetails.groupAiTagsL1,
              aiTagL2: articleDetails.groupAiTagsL2,
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
  final String aiTagL1;
  final String aiTagL2;
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
      required this.aiTagL1,
      required this.aiTagL2,
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
      shareSuccess();
    }
  }

  void shareSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "The Article is shared successfully",
        ),
      ),
    );
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
    if (widget.images.isNotEmpty) {
      height = 100;
    }
    String summary = widget.summary;
    List<String> lines = summary.split('\n');
    lines = lines.map((line) => line.trim()).toList();
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                scrolledUnderElevation: 0.0,
                centerTitle: true,
                elevation: 0.0,
                expandedHeight: height + 50,
                flexibleSpace: Stack(
                  children: [
                    if (widget.images.isNotEmpty)
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 3, left: 20, right: 20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.push(home);
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .withAlpha(150),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_back_sharp,
                                      size: 18,
                                    ),
                                    Text(" Back",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Handle button press
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
                    Positioned(
                      top: height - 15,
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
                  preferredSize: const Size.fromHeight(kToolbarHeight + 40),
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.title.trim(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Animate(
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sources Used',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          ArticleIdS(articleIds: widget.articleIds),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 15,
                        offset:
                            const Offset(0, -3), // changes position of shadow
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            ),
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
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
