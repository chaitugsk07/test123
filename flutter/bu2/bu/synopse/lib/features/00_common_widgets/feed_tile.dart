import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:synopse/core/ads/ad_helper.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/find_friends.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';
import 'package:synopse/features/04_home/ui/widgets/my_user_level.dart';
import 'package:synopse/features/04_home/ui/widgets/side_scrolling_widget.dart';

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
  final bool isbookmarked;
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
      required this.isbookmarked,
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
        isbookmarked: isbookmarked,
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
  final bool isbookmarked;
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
      required this.isbookmarked,
      required this.articleCount,
      required this.type,
      required this.hTag,
      required this.isLoggedin});

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likesCount;
  late bool _isLoggedin;

  BannerAd? _bannerAd;
  NativeAd? _nativeAd;
  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isBookmarked = widget.isbookmarked;
    _likesCount = widget.likesCount;
    _isLoggedin = widget.isLoggedin;
    if (widget.ind % 4 == 0 && widget.ind > 3) {
      loadNativeAd();

      //loadBannerAd();
    }
  }

  void loadNativeAd() {
    NativeAd(
      adUnitId: AdManager.nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAd = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  void loadBannerAd() {
    // COMPLETE: Load a banner ad
    BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // COMPLETE: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
        ),
        child: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Column(
              children: [
                if (widget.ind == 0 && widget.type == 1) const MyUserLevel1(),
                GestureDetector(
                  onTap: () {
                    if (_isLoggedin) {
                      context.push(
                        detail,
                        extra: widget.articleGroupid,
                      );
                    } else if (!_isLoggedin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'You need to be logged in to perform this action.'),
                        ),
                      );
                    }
                  },
                  child: GestureDetector(
                    child: Column(
                      children: [
                        if (widget.ind % 3 == 0 &&
                            widget.images.isNotEmpty &&
                            widget.type == 1)
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
                                images: widget.images,
                              ),
                            ),
                          ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 350.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
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
                                              height: 15,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    widget.logoUrls[index],
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.lastUpdatedat,
                                  style: MyTypography.caption.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Animate(
                          effects: [
                            FadeEffect(
                                delay: 500.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      right: (widget.ind % 3 == 0 &&
                                              widget.images.isEmpty)
                                          ? 0
                                          : 8),
                                  constraints: BoxConstraints(
                                    maxWidth: (widget.ind % 3 == 0 &&
                                            widget.images.isEmpty)
                                        ? width - 50
                                        : width - 108,
                                  ),
                                  child: Text(
                                    widget.title,
                                    style: MyTypography.body,
                                  ),
                                ),
                                const Spacer(),
                                if (widget.ind % 3 != 0 &&
                                    widget.images.isNotEmpty &&
                                    widget.type != 1)
                                  ImageCaresole(
                                    width: 75,
                                    images: widget.images,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 700.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_isLoggedin) {
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
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4),
                          child: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 16,
                          ),
                        ),
                      ),
                      if (_likesCount > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '$_likesCount Likes',
                            style: MyTypography.caption.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      if (widget.commentsCount > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 5,
                          ),
                        ),
                      if (widget.commentsCount > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '${widget.commentsCount} Comments',
                            style: MyTypography.caption.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      if (widget.viewsCount > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 5,
                          ),
                        ),
                      if (widget.viewsCount > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '${widget.viewsCount} Views',
                            style: MyTypography.caption.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      if (widget.isViewed)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ),
                      if (widget.articleCount > 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 5,
                          ),
                        ),
                      if (widget.articleCount > 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '${widget.articleCount} Articles',
                            style: MyTypography.caption.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (_isLoggedin) {
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
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.ind == 7 && widget.type == 1) const FindFriends(),
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 350.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                    thickness: 0.7,
                  ),
                ),
                if (widget.hTag != "na")
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 400.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            widget.hTag,
                            textAlign: TextAlign.start,
                            style: MyTypography.s2.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 450.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: SizedBox(
                          height: 275,
                          width: width,
                          child: SideScrolling1(
                            tag: widget.hTag,
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
                    ],
                  ),
                if (_nativeAd != null && widget.ind % 4 == 0 && widget.ind > 3)
                  FutureBuilder<InitializationStatus>(
                    future: _initGoogleMobileAds(),
                    builder: (BuildContext context,
                        AsyncSnapshot<InitializationStatus> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            Container(
                              height: 72.0,
                              alignment: Alignment.center,
                              child: AdWidget(ad: _nativeAd!),
                            ),
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                              thickness: 0.7,
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error initializing Google Mobile Ads: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                /*if (_bannerAd != null && widget.ind % 4 == 0)
                  FutureBuilder<InitializationStatus>(
                    future: _initGoogleMobileAds(),
                    builder: (BuildContext context,
                        AsyncSnapshot<InitializationStatus> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: [
                            Container(
                              width: _bannerAd!.size.width.toDouble(),
                              height: 72.0,
                              alignment: Alignment.center,
                              child: AdWidget(ad: _bannerAd!),
                            ),
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                              thickness: 0.7,
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error initializing Google Mobile Ads: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ), */
              ],
            );
          },
        ),
      ),
    );
  }
}
