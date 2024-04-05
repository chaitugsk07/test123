import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';

class InshortView111 extends StatelessWidget {
  final List<String> images;
  final String title;
  final List<String> keypoints;
  final String lastUpdatedat;
  final int viewsCount;
  final int likesCount;
  final int articleCount;
  final int articleGroupid;
  final int width;

  const InshortView111(
      {super.key,
      required this.images,
      required this.title,
      required this.keypoints,
      required this.lastUpdatedat,
      required this.viewsCount,
      required this.likesCount,
      required this.articleCount,
      required this.articleGroupid,
      required this.width});

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
      child: InshortView11(
        images: images,
        title: title,
        keypoints: keypoints,
        lastUpdatedat: lastUpdatedat,
        viewsCount: viewsCount,
        likesCount: likesCount,
        articleCount: articleCount,
        articleGroupid: articleGroupid,
        width: width,
      ),
    );
  }
}

class InshortView11 extends StatefulWidget {
  final List<String> images;
  final String title;
  final List<String> keypoints;
  final String lastUpdatedat;
  final int viewsCount;
  final int likesCount;
  final int articleCount;
  final int articleGroupid;
  final int width;

  const InshortView11(
      {super.key,
      required this.images,
      required this.title,
      required this.keypoints,
      required this.lastUpdatedat,
      required this.viewsCount,
      required this.likesCount,
      required this.articleCount,
      required this.articleGroupid,
      required this.width});

  @override
  State<InshortView11> createState() => _InshortView11State();
}

class _InshortView11State extends State<InshortView11> {
  @override
  void initState() {
    super.initState();
    context
        .read<UserEventBloc>()
        .add(UserEventViewInShort(articleGrouppId: widget.articleGroupid));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          detail,
          extra: DetailData(articleGroupid: widget.articleGroupid, type: 1),
        );
      },
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: (widget.width.toDouble() * 9 / 16) + 10,
                    ),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    for (var point in widget.keypoints)
                      Text(
                        "* $point",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 550.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  ' ${widget.likesCount} Likes |',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
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
                  ],
                ),
              ),
            ),
            ImageCaresole(
              width: widget.width.toDouble(),
              height: widget.width.toDouble() * 9 / 16,
              images: widget.images,
              type: 1,
              rounded: 15,
            ),
          ],
        ),
      ),
    );
  }
}
