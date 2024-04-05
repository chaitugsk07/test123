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
import 'package:synopse/features/00_common_widgets/native_ad.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/04_home/widgets/side_scrolling_widget.dart';

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
  late bool _isLoadAd;
  late bool _isHtag;
  late int _setHeight;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;
    _isLoggedin = widget.isLoggedin;
    _userLevel = 0;
    _isLoadAd = false;
    _isHtag = false;
    _setHeight = 115;
    _getAccountFromSharedPreferences();
    if (((widget.type <= 2 && _userLevel == 1 && widget.ind % 5 == 0) ||
            (widget.type <= 2 && _userLevel == 2 && widget.ind % 8 == 0) ||
            (widget.type <= 2 && _userLevel == 3 && widget.ind % 10 == 0) ||
            (widget.type <= 2 && _userLevel == 4 && widget.ind % 15 == 0) ||
            (widget.type <= 2 && _userLevel == 5 && widget.ind % 16 == 0) ||
            (widget.type <= 2 && _userLevel == 6 && widget.ind % 17 == 0)) &&
        widget.ind > 4) {
      _isLoadAd = true;
      _setHeight = 415;
    }
    if (widget.hTag != 'na') {
      _isHtag = true;
      _setHeight = 390;
    }
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
        if (widget.isLoggedin) {
          context.push(
            detail,
            extra: DetailData(articleGroupid: widget.articleGroupid, type: 1),
          );
        } else {
          context.push(
            detailNo,
            extra: DetailData(articleGroupid: widget.articleGroupid, type: 1),
          );
        }
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          height: _setHeight.toDouble(),
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 700,
          ),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      maxLines: 3,
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
                                                horizontal: 1.0),
                                            child: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.grey,
                                              size: 12,
                                            ),
                                          ),
                                        if (widget.viewsCount > 0)
                                          Text(
                                            ' ${widget.viewsCount} Reads | ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: Colors.grey,
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
                                          child: Icon(
                                            _isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.grey,
                                            size: 12,
                                          ),
                                        ),
                                        if (_likesCount > 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              ' $_likesCount Likes |',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(color: Colors.grey),
                                            ),
                                          ),
                                        if (_likesCount == 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              ' 0 Likes |',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(color: Colors.grey),
                                            ),
                                          ),
                                        if (widget.articleCount > 1)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
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
                              )
                            ],
                          ),
                        ),
                        if (widget.images.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 75,
                                width: 75,
                                child: CachedNetworkImage(
                                  imageUrl: widget.images[0],
                                  placeholder: (context, url) => Center(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 350.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 0.5,
                      ),
                    ),
                  ),
                  if (_isHtag)
                    Stack(
                      children: [
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 450.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: SizedBox(
                            height: 275,
                            width: double.infinity,
                            child: SideScrolling1(
                              tag: widget.hTag,
                            ),
                          ),
                        ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 400.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: Text(
                                  widget.hTag,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_isLoadAd)
                    Center(
                      child: NativeAdWidget(
                        textColor: Theme.of(context).colorScheme.onBackground,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
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
