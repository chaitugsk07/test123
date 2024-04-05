import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/native_ad.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/04_home/widgets/my_user_level.dart';

class FeedTileM extends StatelessWidget {
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
  final int articleCount;
  final int type;
  final String hTag;
  final bool isLoggedin;

  const FeedTileM(
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
      required this.articleCount,
      required this.type,
      required this.hTag,
      required this.isLoggedin});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserEventBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: FeedTile(
        images: images,
        logoUrls: logoUrls,
        ind: ind,
        articleGroupid: articleGroupid,
        lastUpdatedat: lastUpdatedat,
        title: title,
        likesCount: likesCount,
        commentsCount: commentsCount,
        viewsCount: viewsCount,
        isLiked: isLiked,
        isViewed: isViewed,
        isCommented: isCommented,
        articleCount: articleCount,
        type: type,
        hTag: hTag,
        isLoggedin: isLoggedin,
      ),
    );
  }
}

class FeedTile extends StatefulWidget {
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
  final int articleCount;
  final int type;
  final String hTag;
  final bool isLoggedin;

  const FeedTile(
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
      required this.articleCount,
      required this.type,
      required this.hTag,
      required this.isLoggedin});

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  late bool _isLiked;
  late int _likesCount;
  late bool _isLoggedin;
  late int _userLevel;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;
    _isLoggedin = widget.isLoggedin;
    _userLevel = 0;
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _userLevel = prefs.getInt('userLevel') ?? 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(detail, extra: widget.articleGroupid);
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 500,
          ),
          child: Builder(
            builder: (context) {
              double screenWidth = MediaQuery.of(context).size.width;
              double width = math.max(300, math.min(screenWidth, 500));
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    if (widget.ind == 0 && widget.type == 1)
                      const MyUserLevel1(),
                    if (widget.ind % 4 == 0 &&
                        widget.images.isNotEmpty &&
                        widget.type <= 2)
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 200.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageCaresole(
                              width: width,
                              height: height,
                              rounded: 18.0,
                              images: widget.images,
                              type: 1),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 350.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 20,
                                        constraints: const BoxConstraints(
                                          maxWidth: 500,
                                        ),
                                        child: ListView.builder(
                                          itemCount: widget.logoUrls.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ClipOval(
                                              child: Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                    height: 15,
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget
                                                          .logoUrls[index],
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          child: Container(
                                                            height: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .background,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 450.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.title.trim(),
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            height: 1.1,
                                            letterSpacing: 0.5,
                                            wordSpacing: 1.5,
                                          ),
                                    ),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: width - 20,
                                      child: Row(
                                        children: [
                                          Text(
                                            "${widget.lastUpdatedat} ago. | ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: Colors.grey,
                                                ),
                                          ),
                                          if (widget.isViewed)
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                            ),
                                          if (widget.viewsCount > 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                '${widget.viewsCount} Reads | ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ),
                                          GestureDetector(
                                            onTap: () {
                                              if (_isLoggedin) {
                                                setState(
                                                  () {
                                                    if (_isLiked) {
                                                      context
                                                          .read<UserEventBloc>()
                                                          .add(
                                                            UserEventLikeDelete(
                                                                articleGrouppId:
                                                                    widget
                                                                        .articleGroupid),
                                                          );
                                                      _likesCount--;
                                                    } else {
                                                      context
                                                          .read<UserEventBloc>()
                                                          .add(
                                                            UserEventLike(
                                                                articleGrouppId:
                                                                    widget
                                                                        .articleGroupid),
                                                          );
                                                      _likesCount++;
                                                    }
                                                    _isLiked = !_isLiked;
                                                  },
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4),
                                              child: Icon(
                                                _isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                          if (_likesCount > 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                '$_likesCount Likes |',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            ),
                                          if (_likesCount == 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                '0 Likes |',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            ),
                                          if (widget.articleCount > 1)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                '${widget.articleCount} Articles',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if ((widget.type <= 2 &&
                                widget.ind % 4 != 0 &&
                                widget.images.isNotEmpty) ||
                            (widget.type == 3 && widget.images.isNotEmpty))
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: ImageCaresole(
                              width: 90,
                              height: 90,
                              rounded: 8.0,
                              images: widget.images,
                              type: 2,
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
                        color: Colors.grey[300],
                        thickness: 0.5,
                      ),
                    ),
                    if (((widget.type <= 2 &&
                                _userLevel == 1 &&
                                widget.ind % 5 == 0) ||
                            (widget.type <= 2 &&
                                _userLevel == 2 &&
                                widget.ind % 8 == 0) ||
                            (widget.type <= 2 &&
                                _userLevel == 3 &&
                                widget.ind % 10 == 0) ||
                            (widget.type <= 2 &&
                                _userLevel == 4 &&
                                widget.ind % 15 == 0) ||
                            (widget.type <= 2 &&
                                _userLevel == 5 &&
                                widget.ind % 16 == 0) ||
                            (widget.type <= 2 &&
                                _userLevel == 6 &&
                                widget.ind % 17 == 0)) &&
                        widget.ind > 4)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NativeAdWidget(
                            textColor:
                                Theme.of(context).colorScheme.onBackground,
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
