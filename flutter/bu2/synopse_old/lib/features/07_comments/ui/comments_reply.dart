import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/07_comments/bloc/comments1_articles/comments1_article_bloc.dart';
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
          create: (context) => Comments1ArticleBloc(
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

          final bool isLiked =
              c1r1.articleCommentLikesAggregate?.aggregate?.count == 0
                  ? false
                  : true;
          final bool isDisliked =
              c1r1.articleCommentDislikesAggregate?.aggregate?.count == 0
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
  const CommentsReplys({
    super.key,
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
  });

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
    context.read<Comments1ArticleBloc>().add(
          Comments1ArticleFetch(articleGroupId: widget.articleGroupId),
        );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.push(comments, extra: widget.articleGroupId);
          },
        ),
        title: const Text('Reply'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<Comments1ArticleBloc, Comments1ArticleState>(
                      builder: (context, comments1ArticleState) {
                        if (comments1ArticleState.status ==
                            Comments1ArticleStatus.success) {
                          final searchResult = comments1ArticleState
                              .synopseArticlesTV4ArticleGroupsL2Detail[0];
                          final images = searchResult.imageUrls;
                          images.shuffle();
                          final logoUrls = searchResult.logoUrls;
                          logoUrls.shuffle();
                          final articleGroupId = searchResult.articleGroupId;
                          final lastUpdatedat = searchResult
                              .articleDetailLink!.updatedAtFormatted;
                          final title = searchResult.title;
                          final likescount =
                              searchResult.articleDetailLink!.likesCount;
                          final viewcount =
                              searchResult.articleDetailLink!.viewsCount;
                          final commentcount =
                              searchResult.articleDetailLink!.commentsCount;
                          final isliked = searchResult
                                      .tUserArticleLikesAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final isviewed = searchResult
                                      .tUserArticleViewsAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final iscommented = searchResult
                                      .tUserArticleCommentsAggregate!
                                      .aggregate!
                                      .count ==
                                  0
                              ? false
                              : true;
                          final articlecount =
                              searchResult.articleDetailLink!.articleCount;
                          String htag = 'na';
                          return FeedTileM(
                            ind: 0,
                            articleGroupid: articleGroupId,
                            images: images,
                            logoUrls: logoUrls,
                            lastUpdatedat: lastUpdatedat,
                            title: title,
                            likesCount: likescount,
                            viewsCount: viewcount,
                            commentsCount: commentcount,
                            isLiked: isliked,
                            isViewed: isviewed,
                            isCommented: iscommented,
                            articleCount: articlecount,
                            type: 3,
                            hTag: htag,
                            isLoggedin: true,
                          );
                        } else {
                          return Container();
                        }
                      },
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
                        type: 2,
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
                                          .articleCommentLikesAggregate
                                          ?.aggregate
                                          ?.count ==
                                      0
                                  ? false
                                  : true;
                              final bool isDislikedR = comments1RState
                                          .synopseRealtimeVUserArticleComment[
                                              index]
                                          .articleCommentDislikesAggregate
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
                                    type: 1,
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
