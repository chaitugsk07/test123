import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:rss1_v2/core/routing/routes.dart';
import 'package:rss1_v2/presentation/feed/article_feed.cubit.dart';
import 'package:rss1_v2/presentation/feed/models/ui_article_feed.dart';

buildArticleListWidget({
  required BuildContext context,
  required TextEditingController searchTextController,
  AnimationController? animationController,
  required List<UiRss1Artical> articlesList,
  required Null Function() onScrolledToEndCallback,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: FutureBuilder<bool>(
              future: delay(),
              builder: (
                BuildContext context,
                AsyncSnapshot<bool> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.pixels ==
                          scrollNotification.metrics.maxScrollExtent) {
                        onScrolledToEndCallback();
                      }
                      return false;
                    },
                    child: MasonryGridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemCount: articlesList.length,
                      itemBuilder: (context, index) {
                        final count = articlesList.length;
                        animationController?.forward();
                        return ArticleItemWidget(
                          key: Key('articleItem:$index'),
                          article: articlesList[index],
                          animation: getListAnimation(
                            count,
                            index,
                            animationController!,
                          ),
                          animationController: animationController,
                        );
                      },
                    ),
                  );
                }
              }),
        ),
      ),
    ],
  );
}

Future<bool> delay() async {
  await Future<dynamic>.delayed(const Duration(milliseconds: 100));
  return true;
}

Animation<double> getListAnimation(
  int count,
  int index,
  AnimationController animationController,
) {
  return Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Interval(
        (1 / count) * index,
        1,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    ),
  );
}

class ArticleItemWidget extends StatelessWidget {
  const ArticleItemWidget(
      {super.key, this.article, this.animationController, this.animation});

  final UiRss1Artical? article;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    //print(state.rss1Articals[index].title);
    final random = Random();
    const min = 1;
    const max = 5;
    final randomNumber = min + random.nextInt(max - min);
    String formattedDifference;

    final now = DateTime.now().toUtc();
    final postPublished = article!.postPublished.toUtc();
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (randomNumber == 1 && article!.isDefaultImage == 1)
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
                          child: Image.network(
                            article!.imageLink,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                          article!.rss1LinkByRss1Link.rss1Outlet.logoUrl),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    article!.rss1LinkByRss1Link.rss1Outlet.outletDisplay,
                    style: const TextStyle(
                        fontSize: 10, fontFamily: 'Roboto condensed'),
                  ),
                  const SizedBox(width: 10),
                  Text(formattedDifference,
                      style: const TextStyle(
                          fontSize: 8,
                          fontFamily: 'Roboto condensed',
                          color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article!.title,
                        ),
                        Text(
                          article!.summary,
                        ),
                      ],
                    ),
                  ),
                  if (randomNumber != 1 && article!.isDefaultImage == 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            article!.imageLink,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Divider(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                thickness: 0.1,
              ), // draws a gray line
            ],
          );
        }),
      ),
    );
  }
}
