import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rss1_v8/core/routes/routes.dart';
import 'package:rss1_v8/feed/20_presentation_mapping/ui_articlesrss1.dart';

Widget buildarticlesRss1ListWidget({
  required BuildContext context,
  required TextEditingController searchTextController,
  required AnimationController? animationController,
  required List<UiArticleRss1> articlesRss1List,
  required Function onScrolledToEndCallback,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
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
                  child: GridView(
                    key: const Key('articalRss1ListView'),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    children: List<Widget>.generate(
                      articlesRss1List.length,
                      (int index) {
                        final count = articlesRss1List.length;
                        animationController?.forward();
                        return AricleRss1ItemWidget(
                          key: Key('articleItem:$index'),
                          callback: (articleRss1Id) {
                            // Navigate to articleRss1 information
                            context.push(
                              articleRss1RouteLink,
                              extra: articleRss1Id,
                            );
                          },
                          articleRss1: articlesRss1List[index],
                          animation: getListAnimation(
                            count,
                            index,
                            animationController!,
                          ),
                          animationController: animationController,
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      )
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

class AricleRss1ItemWidget extends StatelessWidget {
  const AricleRss1ItemWidget({
    super.key,
    this.articleRss1,
    this.animationController,
    this.animation,
    required this.callback,
  });

  final void Function(String) callback;
  final UiArticleRss1? articleRss1;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0,
              50 * (1.0 - animation!.value),
              0,
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback(articleRss1?.postLink ?? '');
              },
              child: SizedBox(
                height: 290,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Color(0xffedeff0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              // border: new Border.all(
                              //     color: DesignCourseAppTheme.notWhite),
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16,
                                          left: 16,
                                          right: 16,
                                        ),
                                        child: Text(
                                          articleRss1!.title ?? '',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.27,
                                            color: Color(0xff807e7e),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 8,
                                          right: 8,
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              articleRss1!.outlet ?? '',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: Color(0xff807e7e),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              '.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: Color(0xff807e7e),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              articleRss1!.postPublished ?? '',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: Color(0xff6e6d6d),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 48,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child:
                                    Image.network(articleRss1!.imageLink ?? ''),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
