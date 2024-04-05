import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/image_caresol.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';

class UserSavedTiles extends StatelessWidget {
  final List<String> images;
  final List<String> logoUrls;
  final int articleGroupid;
  final String title;
  final bool isbookmarked;

  const UserSavedTiles(
      {super.key,
      required this.images,
      required this.logoUrls,
      required this.articleGroupid,
      required this.title,
      required this.isbookmarked});

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
      child: UserSavedTile(
        images: images,
        logoUrls: logoUrls,
        articleGroupid: articleGroupid,
        title: title,
        isbookmarked: isbookmarked,
      ),
    );
  }
}

class UserSavedTile extends StatefulWidget {
  final List<String> images;
  final List<String> logoUrls;
  final int articleGroupid;
  final String title;
  final bool isbookmarked;

  const UserSavedTile(
      {super.key,
      required this.images,
      required this.logoUrls,
      required this.articleGroupid,
      required this.title,
      required this.isbookmarked});

  @override
  State<UserSavedTile> createState() => _UserSavedTileState();
}

class _UserSavedTileState extends State<UserSavedTile> {
  late bool _isBookmarked;
  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isbookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width - 150,
                      child: ListView.builder(
                        itemCount: widget.logoUrls.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Animate(
                            effects: [
                              FadeEffect(
                                  delay: 300.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: ClipOval(
                              child: Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 15,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.logoUrls[index],
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (_isBookmarked)
                    GestureDetector(
                      onTap: () {
                        context.read<UserEventBloc>().add(
                            UserEventBookmarkDelete(
                                articleGrouppId: widget.articleGroupid));
                        setState(() {
                          _isBookmarked = false;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.bookmark, size: 15),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 400.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ImageCaresole(
                        width: 100,
                        images: widget.images,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: MyTypography.body,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
