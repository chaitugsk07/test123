import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';
import 'package:synopse/features/07_comments/bloc/comments1_bloc.dart';
import 'package:synopse/features/07_comments/ui/comment_tile.dart';

class Comments1 extends StatelessWidget {
  final int articleGroupId;

  const Comments1({
    super.key,
    required this.articleGroupId,
  });

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
        BlocProvider(
          create: (context) => Comments1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: Comments(
        articleGroupId: articleGroupId,
      ),
    );
  }
}

class Comments extends StatefulWidget {
  final int articleGroupId;

  const Comments({
    super.key,
    required this.articleGroupId,
  });
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _textEditingController = TextEditingController();
  late String account;
  late int userLevel;
  @override
  void initState() {
    super.initState();
    userLevel = 0;
    _textEditingController.addListener(() {
      setState(() {});
    });
    context.read<Comments1Bloc>().add(
          Comments1Fetch(articleGroupId: widget.articleGroupId),
        );
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      account = prefs.getString('account') ?? '';
      userLevel = prefs.getInt("userLevel") ?? 0;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments', style: MyTypography.t1),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<Comments1Bloc, Comments1State>(
                        builder: (context, comments1State) {
                          if (comments1State.status ==
                              Comments1Status.initial) {
                            return const Center(
                              child: PageLoading(),
                            );
                          }
                          if (comments1State.status ==
                              Comments1Status.success) {
                            return Column(
                              children: [
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 350.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 20,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ListView.builder(
                                          itemCount: comments1State
                                              .synopseRealtimeVUserArticleComment[
                                                  0]
                                              .commentToArticleGroup!
                                              .logoUrls
                                              .length,
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
                                                      imageUrl: comments1State
                                                          .synopseRealtimeVUserArticleComment[
                                                              0]
                                                          .commentToArticleGroup!
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
                                    child: Text(
                                      comments1State
                                          .synopseRealtimeVUserArticleComment[0]
                                          .commentToArticleGroup!
                                          .title,
                                      style: MyTypography.body,
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
                                    thickness: 0.4,
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: comments1State
                                      .synopseRealtimeVUserArticleComment
                                      .length,
                                  itemBuilder: (context, index) {
                                    final bool isLiked = comments1State
                                                .synopseRealtimeVUserArticleComment[
                                                    index]
                                                .commentToUserComment
                                                ?.tUserCommentLikesAggregate
                                                ?.aggregate
                                                ?.count ==
                                            0
                                        ? false
                                        : true;
                                    final bool isDisliked = comments1State
                                                .synopseRealtimeVUserArticleComment[
                                                    index]
                                                .commentToUserComment
                                                ?.tUserCommentDislikesAggregate
                                                ?.aggregate
                                                ?.count ==
                                            0
                                        ? false
                                        : true;
                                    final bool isEdited = comments1State
                                                .synopseRealtimeVUserArticleComment[
                                                    index]
                                                .isEdited ==
                                            0
                                        ? false
                                        : true;
                                    final bool isOwner = comments1State
                                                .synopseRealtimeVUserArticleComment[
                                                    index]
                                                .account ==
                                            account
                                        ? true
                                        : false;
                                    return Animate(
                                      effects: [
                                        FadeEffect(
                                            delay: 600.milliseconds,
                                            duration: 1000.milliseconds)
                                      ],
                                      child: Comments1Tile(
                                        userName: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .username,
                                        name: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .name,
                                        photoUrl: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .photourl,
                                        comment: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .comment,
                                        articleGroupId: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .articleGroupId,
                                        updatedAtFormatted: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .updatedAtFormatted,
                                        likesCount: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .commentsLikeCount,
                                        dislikesCount: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .commentsDislikeCount,
                                        isLiked: isLiked,
                                        isDisliked: isDisliked,
                                        isEdited: isEdited,
                                        replyCount: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .commentsReplyCount,
                                        commentId: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .id,
                                        account: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                index]
                                            .account,
                                        isOwner: isOwner,
                                        title: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                0]
                                            .commentToArticleGroup!
                                            .title,
                                        logoUrls: comments1State
                                            .synopseRealtimeVUserArticleComment[
                                                0]
                                            .commentToArticleGroup!
                                            .logoUrls,
                                        type: 3,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Animate(
                  effects: [
                    SlideEffect(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                      delay: 100.microseconds,
                      duration: 1000.milliseconds,
                      curve: Curves.easeInOutCubic,
                    ),
                  ],
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 15),
                            cursorColor: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            decoration: InputDecoration(
                              hintText: "Write a comment",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 15, color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_textEditingController.text.isNotEmpty &&
                                userLevel >= 3) {
                              context.read<UserEventBloc>().add(
                                    UserEventCommentSet(
                                      articleGrouppId: widget.articleGroupId,
                                      comment: _textEditingController.text,
                                    ),
                                  );
                              final currentState =
                                  context.read<UserEventBloc>().state;
                              if (currentState.status !=
                                  UserEventStatus.initial) {
                                context.read<Comments1Bloc>().add(
                                      Comments1Fetch(
                                          articleGroupId:
                                              widget.articleGroupId),
                                    );
                              }
                            } else if (userLevel <= 4) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('You need to be level 4 to comment'),
                                ),
                              );
                            }
                            _textEditingController.clear();
                          },
                          icon: const Icon(Icons.send),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
