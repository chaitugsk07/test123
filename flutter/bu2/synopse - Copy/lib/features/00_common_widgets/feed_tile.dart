import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/native_ad.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
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
                    child: Column(
                      children: [
                        if (widget.ind == 0 && widget.type == 2)
                          const SizedBox(
                            height: 10,
                          ),
                        if (widget.ind % 3 == 0 &&
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
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
                                  constraints: BoxConstraints(
                                    maxWidth: ((widget.ind % 3 == 0 ||
                                                widget.images.isEmpty) &&
                                            widget.type <= 2)
                                        ? width - 50
                                        : width - 120,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(widget.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                ),
                                const Spacer(),
                                if (widget.ind % 3 != 0 &&
                                    widget.images.isNotEmpty &&
                                    widget.type <= 2)
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
                      const SizedBox(
                        width: 5,
                      ),
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
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ),
                      ),
                      if (_likesCount > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '$_likesCount',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.grey),
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
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
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
                            '${widget.viewsCount} Reads',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      const Spacer(),
                    ],
                  ),
                ),
                //if (widget.ind == 7 && widget.type == 1) const FindFriends(),
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
                            style: Theme.of(context).textTheme.titleLarge,
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
                        textColor: Theme.of(context).colorScheme.onBackground,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
