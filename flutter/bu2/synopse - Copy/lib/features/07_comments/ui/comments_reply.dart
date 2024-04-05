import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/07_comments/bloc/comments1_r/comments1_r_bloc.dart';
import 'package:synopse/features/07_comments/bloc/comments_reply/comments1_reply_bloc.dart';
import 'package:synopse/features/07_comments/ui/comment_tile.dart';

class Comments1Reply extends StatelessWidget {
  final int commentMainId;

  const Comments1Reply({super.key, required this.commentMainId});

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
          create: (context) => Comments1RBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => Comments1R1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          )..add(Comments1R1Fetch(commnentId: commentMainId)),
        ),
      ],
      child: BlocBuilder<Comments1R1Bloc, Comments1R1State>(
          builder: (context, comments1R1State) {
        if (comments1R1State.status == Comments1R1Status.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (comments1R1State.status == Comments1R1Status.success) {
          final c1r1 = comments1R1State.synopseRealtimeVUserArticleComment[0];

          final bool isLiked = c1r1.commentToUserComment
                      ?.tUserCommentLikesAggregate?.aggregate?.count ==
                  0
              ? false
              : true;
          final bool isDisliked = c1r1.commentToUserComment
                      ?.tUserCommentDislikesAggregate?.aggregate?.count ==
                  0
              ? false
              : true;
          final bool isEdited = c1r1.isEdited == 0 ? false : true;
          return CommentsReplys(
            name: c1r1.name,
            userName: c1r1.username,
            photoUrl: c1r1.photourl,
            comment: c1r1.comment,
            articleGroupId: c1r1.articleGroupId,
            updatedAtFormatted: c1r1.updatedAtFormatted,
            likesCount: c1r1.commentsLikeCount,
            dislikesCount: c1r1.commentsDislikeCount,
            isLiked: isLiked,
            isDisliked: isDisliked,
            isEdited: isEdited,
            replyCount: c1r1.commentsReplyCount,
            commentId: c1r1.id,
            account: c1r1.account,
            title: c1r1.commentToArticleGroup!.title,
            logoUrls: c1r1.commentToArticleGroup!.logoUrls,
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class CommentsReplys extends StatefulWidget {
  final String name;
  final String userName;
  final String photoUrl;
  final String comment;
  final int articleGroupId;
  final String updatedAtFormatted;
  final int likesCount;
  final int dislikesCount;
  final bool isLiked;
  final bool isDisliked;
  final bool isEdited;
  final int replyCount;
  final int commentId;
  final String account;
  final String title;
  final List<String> logoUrls;
  const CommentsReplys(
      {super.key,
      required this.name,
      required this.userName,
      required this.photoUrl,
      required this.comment,
      required this.articleGroupId,
      required this.updatedAtFormatted,
      required this.likesCount,
      required this.dislikesCount,
      required this.isLiked,
      required this.isDisliked,
      required this.isEdited,
      required this.replyCount,
      required this.commentId,
      required this.account,
      required this.title,
      required this.logoUrls});

  @override
  State<CommentsReplys> createState() => _CommentsReplysState();
}

class _CommentsReplysState extends State<CommentsReplys> {
  final TextEditingController _textEditingController = TextEditingController();
  late String account;
  late int userLevel;
  late bool _isOwner;
  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {});
    });
    userLevel = 0;
    _isOwner = false;
    context
        .read<Comments1RBloc>()
        .add(Comments1RFetch(commentId: widget.commentId));
    _getAccountFromSharedPreferences();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      account = prefs.getString('account') ?? '';
      userLevel = prefs.getInt('userLevel') ?? 0;
      _isOwner = widget.account == account ? true : false;
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
        title: const Text(
          'Reply',
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: SingleChildScrollView(
                child: Column(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                          widget.title,
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
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 500.milliseconds,
                            duration: 1000.milliseconds)
                      ],
                      child: Comments1Tile(
                        name: widget.name,
                        userName: widget.userName,
                        photoUrl: widget.photoUrl,
                        comment: widget.comment,
                        articleGroupId: widget.articleGroupId,
                        updatedAtFormatted: widget.updatedAtFormatted,
                        likesCount: widget.likesCount,
                        dislikesCount: widget.dislikesCount,
                        isLiked: widget.isLiked,
                        isDisliked: widget.isDisliked,
                        isEdited: widget.isEdited,
                        replyCount: widget.replyCount,
                        commentId: widget.commentId,
                        account: widget.account,
                        isOwner: _isOwner,
                        title: widget.title,
                        logoUrls: widget.logoUrls,
                        type: 2,
                      ),
                    ),
                    Animate(
                      effects: [
                        FadeEffect(
                            delay: 500.milliseconds,
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
                    BlocBuilder<Comments1RBloc, Comments1RState>(
                      builder: (context, comments1RState) {
                        if (comments1RState.status ==
                            Comments1RStatus.initial) {
                          return const Center(
                            child: PageLoading(),
                          );
                        } else if (comments1RState.status ==
                            Comments1RStatus.success) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments1RState
                                .synopseRealtimeVUserArticleComment.length,
                            itemBuilder: (context, index) {
                              final bool isLikedR = comments1RState
                                          .synopseRealtimeVUserArticleComment[
                                              index]
                                          .commentToUserComment
                                          ?.tUserCommentLikesAggregate
                                          ?.aggregate
                                          ?.count ==
                                      0
                                  ? false
                                  : true;
                              final bool isDislikedR = comments1RState
                                          .synopseRealtimeVUserArticleComment[
                                              index]
                                          .commentToUserComment
                                          ?.tUserCommentDislikesAggregate
                                          ?.aggregate
                                          ?.count ==
                                      0
                                  ? false
                                  : true;
                              final bool isEditedR = comments1RState
                                          .synopseRealtimeVUserArticleComment[
                                              index]
                                          .isEdited ==
                                      0
                                  ? false
                                  : true;
                              final bool isOwnerR = comments1RState
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Comments1Tile(
                                    userName: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .username,
                                    name: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .name,
                                    photoUrl: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .photourl,
                                    comment: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .comment,
                                    articleGroupId: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .articleGroupId,
                                    updatedAtFormatted: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .updatedAtFormatted,
                                    likesCount: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .commentsLikeCount,
                                    dislikesCount: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .commentsDislikeCount,
                                    isLiked: isLikedR,
                                    isDisliked: isDislikedR,
                                    isEdited: isEditedR,
                                    replyCount: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .commentsReplyCount,
                                    commentId: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .id,
                                    account: comments1RState
                                        .synopseRealtimeVUserArticleComment[
                                            index]
                                        .account,
                                    isOwner: isOwnerR,
                                    title: widget.title,
                                    logoUrls: widget.logoUrls,
                                    type: 3,
                                  ),
                                ),
                              );
                            },
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
                            hintText: "Write a reply",
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
                            var userComment =
                                BlocProvider.of<UserEventBloc>(context)
                                  ..add(
                                    UserEventCommentReply(
                                      commentId: widget.commentId,
                                      comment: _textEditingController.text,
                                      articleGroupId: widget.articleGroupId,
                                    ),
                                  );

                            userComment.stream.listen(
                              (state) {
                                if (state.status != UserEventStatus.initial) {
                                  context.push(commentsReply,
                                      extra: widget.commentId);
                                }
                              },
                            );
                          } else if (userLevel <= 5) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('You need to be level 5 to reply'),
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
      ),
    );
  }
}
