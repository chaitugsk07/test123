import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/article_original_feed/articles_original_bloc.dart';

class BuildArticle1 extends StatelessWidget {
  final ArticlesOriginalState state;
  final int index;
  final bool isLoggedIn;
  final String buildType;
  const BuildArticle1(
      {Key? key,
      required this.state,
      required this.index,
      required this.isLoggedIn,
      required this.buildType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDifference;

    final now = DateTime.now().toUtc();
    final postPublished =
        state.articlesTV1Rss1Artical[index].postPublished!.toUtc();
    final difference = now.toUtc().difference(postPublished);

    if (difference.inMinutes < 60) {
      formattedDifference = '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      formattedDifference = '${difference.inHours}h';
    } else {
      formattedDifference = '${difference.inDays}d';
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
        ),
        child: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
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
                                      imageUrl: state
                                          .articlesTV1Rss1Artical[index]
                                          .tV1Rss1FeedLink!
                                          .tV1Outlet!
                                          .logoUrl,
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
                                child: Text(formattedDifference,
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
                              state.articlesTV1Rss1Artical[index].title,
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
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                              imageUrl:
                                  state.articlesTV1Rss1Artical[index].imageLink,
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
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 350.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
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
