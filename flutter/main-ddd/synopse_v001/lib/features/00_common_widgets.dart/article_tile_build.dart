import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/asset_gen/assets.gen.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/flip_icons.dart';
import 'package:synopse_v001/features/04_home/bloc/articles_rss1_bloc.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/set_like_view_comment/set_like_view_comment_bloc.dart';

class BuildArticle extends StatelessWidget {
  final ArticlesRss1State state;
  final int index;
  final bool isLoggedIn;
  final String buildType;
  const BuildArticle(
      {Key? key,
      required this.state,
      required this.index,
      required this.isLoggedIn,
      required this.buildType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int randomNumber = 0;

    if (index == 0 || index % 3 == 0) {
      randomNumber = 1;
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
        ),
        child: Builder(builder: (context) {
          var url = "";
          bool isliked = false;
          bool isviewed = false;
          int likesCount =
              state.articlesVArticlesMain[index].likesCount.toInt();
          int commentCount =
              state.articlesVArticlesMain[index].commentsCount.toInt();

          int viewsCount =
              state.articlesVArticlesMain[index].viewsCount.toInt();
          var likes = state.articlesVArticlesMain[index].articlesLikes;
          if (likes != null) {
            isliked = true;
          }
          var views = state.articlesVArticlesMain[index].articlesViews;
          if (views != null) {
            isviewed = true;
          }
          return GestureDetector(
            onTap: () {
              if (!isLoggedIn) {
                context.push(login);
              } else if (isLoggedIn) {
                if (!isviewed) {
                  final bloc = context.read<SetLikeViewCommentBloc>();
                  bloc.add(SetLikeViewCommentEventSetLike(
                      action: 'InsertView',
                      articleGroupId:
                          state.articlesVArticlesMain[index].articleGroupId));
                }
                context.push(detail,
                    extra: state.articlesVArticlesMain[index].articleGroupId);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (randomNumber == 1 &&
                    state.articlesVArticlesMain[index].imageUrls.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.constrainWidth(500),
                          height: constraints.constrainWidth(500) * 9 / 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Animate(
                              effects: [
                                FadeEffect(
                                    delay: 100.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: CachedNetworkImage(
                                imageUrl: state
                                    .articlesVArticlesMain[index].imageUrls[0],
                                placeholder: (context, url) =>
                                    const ImageShimmer(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              for (url in state
                                  .articlesVArticlesMain[index].logoUrls)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 150.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl: url,
                                        placeholder: (context, url) =>
                                            const ImageShimmer(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 200.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Text(
                                    state.articlesVArticlesMain[index]
                                        .updatedAtFormatted
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 8,
                                        fontFamily: 'Roboto condensed',
                                        color: Colors.grey)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 250.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Text(
                              state.articlesVArticlesMain[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontFamily: 'Roboto condensed',
                                      fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 300.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Row(
                              children: [
                                if (!isLoggedIn)
                                  Icon(
                                    Icons.favorite_border,
                                    size: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.5),
                                  ),
                                if (isLoggedIn)
                                  isliked
                                      ? Icon(
                                          Icons.favorite,
                                          size: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.5),
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          size: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.5),
                                        ),
                                if (likesCount > 0)
                                  Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      Text(
                                        likesCount.toString() + " likes",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontFamily: 'Roboto condensed',
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ],
                                  ),
                                if (commentCount > 0)
                                  Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 2,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        commentCount.toString() + " comments",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontFamily: 'Roboto condensed',
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ],
                                  ),
                                if (viewsCount > 0)
                                  Row(
                                    children: [
                                      const SizedBox(width: 6),
                                      const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 2,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        viewsCount.toString() + " reads",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontFamily: 'Roboto condensed',
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                      const SizedBox(width: 3),
                                      if (isviewed)
                                        Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withOpacity(0.5),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (randomNumber != 1 &&
                        state.articlesVArticlesMain[index].imageUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Animate(
                              effects: [
                                FadeEffect(
                                    delay: 300.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: CachedNetworkImage(
                                imageUrl: state
                                    .articlesVArticlesMain[index].imageUrls[0],
                                placeholder: (context, url) =>
                                    const ImageShimmer(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (index == 5 && buildType == "feed")
                  Column(
                    children: [
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 350.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.5),
                          thickness: 0.1,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 85,
                                            ),
                                            FlipIcons(
                                              containerColor: Colors
                                                  .deepOrangeAccent
                                                  .withOpacity(0.8),
                                              faIcon: FontAwesomeIcons.hashtag,
                                              size: 30,
                                            ),
                                            const Spacer(),
                                            const FlipIcons(
                                              containerColor:
                                                  Colors.deepPurpleAccent,
                                              faIcon:
                                                  FontAwesomeIcons.newspaper,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        Row(
                                          children: [
                                            FlipIcons(
                                              containerColor: Colors
                                                  .deepOrangeAccent
                                                  .withOpacity(0.9),
                                              faIcon: FontAwesomeIcons.at,
                                              size: 30,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            FlipIcons(
                                              containerColor: Colors
                                                  .deepPurpleAccent
                                                  .withOpacity(0.7),
                                              faIcon: FontAwesomeIcons.share,
                                              size: 30,
                                            ),
                                            const SizedBox(
                                              width: 35,
                                            ),
                                            FlipIcons(
                                              containerColor: Colors
                                                  .deepPurpleAccent
                                                  .withOpacity(0.6),
                                              faIcon:
                                                  FontAwesomeIcons.addressBook,
                                              size: 30,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Animate(
                                          effects: [
                                            FadeEffect(delay: 1000.milliseconds)
                                          ],
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: RichText(
                                              text: TextSpan(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                        fontSize: 30,
                                                        color: Colors.teal),
                                                children: [
                                                  const TextSpan(
                                                      text:
                                                          "Find & Follow Your"),
                                                  TextSpan(
                                                    text: "FrienDS",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors
                                                            .teal.shade700),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Animate(
                                    effects: [
                                      ScaleEffect(
                                          delay: 1000.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: Center(
                                        child: Assets.images.logo
                                            .image(width: 150, height: 150)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 400.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Text(
                                  "See posts and comments from people you know.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontSize: 15),
                                ),
                              ),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 400.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Text(
                                  "Synopse is more fun with friends",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontSize: 15),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 500.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.1),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Find Friends",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    thickness: 0.1,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
