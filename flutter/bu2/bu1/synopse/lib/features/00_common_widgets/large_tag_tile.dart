import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';

class LargeTagTileM extends StatelessWidget {
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

  const LargeTagTileM(
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
      child: LargeTagTile(
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

class LargeTagTile extends StatefulWidget {
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

  const LargeTagTile(
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
  State<LargeTagTile> createState() => _LargeTagTileState();
}

class _LargeTagTileState extends State<LargeTagTile> {
  late bool _isLiked;
  late bool _isBookmarked;
  late int _likesCount;
  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isBookmarked = widget.isbookmarked;
    _likesCount = widget.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Animate(
        effects: [
          FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
        ],
        child: SizedBox(
          width: 300,
          height: 225,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    /*context.push(
                      detail,
                      extra: widget.articleGroupid,
                    );*/
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ImageCaresole(
                            width: 310,
                            images: widget.images,
                          ),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 350.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Positioned(
                              bottom: 10,
                              left: 10,
                              child: Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 500.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 20,
                                        constraints: const BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.5),
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
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(),
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Animate(
                                        effects: [
                                          FadeEffect(
                                              delay: 600.milliseconds,
                                              duration: 1000.milliseconds)
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background
                                                  .withOpacity(0.7)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 3),
                                            child: Text(
                                              widget.lastUpdatedat,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 700.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 800.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      height: 20,
                      child: Animate(
                        effects: [
                          FadeEffect(
                              delay: 700.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Row(
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 4),
                                child: Icon(
                                  _isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  size: 16,
                                ),
                              ),
                            ),
                            if (_likesCount > 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  '$_likesCount',
                                ),
                              ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.circle,
                                color: Colors.grey,
                                size: 5,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.comment_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ),
                            if (widget.commentsCount > 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  '${widget.commentsCount}',
                                ),
                              ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.circle,
                                color: Colors.grey,
                                size: 5,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ),
                            if (widget.viewsCount > 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  '${widget.viewsCount}',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  '${widget.articleCount} Articles',
                                ),
                              ),
                            const Spacer(),
                            GestureDetector(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}