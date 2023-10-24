import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/06_comments/bloc/article_summarry/article_summary_bloc.dart';

class ArticleShortSummary extends StatelessWidget {
  final ArticleSummaryShortState articleSummaryShortState;
  const ArticleShortSummary({
    Key? key,
    required this.articleSummaryShortState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 25,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: articleSummaryShortState
                          .articlesVArticlesMain[0].logoUrls.length,
                      itemBuilder: (context, index) {
                        final url = articleSummaryShortState
                            .articlesVArticlesMain[0].logoUrls[index];
                        return Animate(
                          effects: [
                            FadeEffect(
                                delay: 200.milliseconds,
                                duration: 1000.milliseconds)
                          ],
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                placeholder: (context, url) =>
                                    const ImageShimmer(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 300.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
                    child: Text(
                      textAlign: TextAlign.center,
                      articleSummaryShortState.articlesVArticlesMain[0].title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
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
                          delay: 300.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: CachedNetworkImage(
                      imageUrl: articleSummaryShortState
                          .articlesVArticlesMain[0].imageUrls[0],
                      placeholder: (context, url) => const ImageShimmer(),
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
            FadeEffect(delay: 300.milliseconds, duration: 1000.milliseconds)
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.start,
              articleSummaryShortState.articlesVArticlesMain[0].summary60Words,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 12, height: 1.5, wordSpacing: 2),
            ),
          ),
        ),
        Animate(
          effects: [
            FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
          ],
          child: Divider(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            thickness: 0.1,
          ),
        ),
      ],
    );
  }
}
