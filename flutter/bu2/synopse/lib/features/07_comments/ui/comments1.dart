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
import 'package:synopse/features/07_comments/bloc/comments1/comments1_bloc.dart';
import 'package:synopse/features/07_comments/bloc/comments1_articles/comments1_article_bloc.dart';
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
        BlocProvider(
          create: (context) => Comments1ArticleBloc(
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
    context.read<Comments1ArticleBloc>().add(
          Comments1ArticleFetch(articleGroupId: widget.articleGroupId),
        );
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.push(detail, extra: widget.articleGroupId);
            },
          ),
          title: const Text('Comments'),
          centerTitle: true,
        ),
        body: Stack(
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
                    BlocBuilder<Comments1Bloc, Comments1State>(
                      builder: (context, comments1State) {
                        if (comments1State.status == Comments1Status.initial) {
                          return const Center(
                            child: PageLoading(),
                          );
                        }
                        if (comments1State.status == Comments1Status.success) {
                          final bool isNoComments = comments1State
                                  .synopseRealtimeVUserArticleComment.isEmpty
                              ? true
                              : false;
                          return Column(
                            children: [
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 350.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Column(
                                  children: [
                                    if (isNoComments)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 25,
                                        ),
                                        child: Center(
                                          child: Text(
                                              "Be the first to comment on this article"),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: comments1State
                                    .synopseRealtimeVUserArticleComment.length,
                                itemBuilder: (context, index) {
                                  final bool isLiked = comments1State
                                              .synopseRealtimeVUserArticleComment[
                                                  index]
                                              .articleCommentLikesAggregate
                                              ?.aggregate
                                              ?.count ==
                                          0
                                      ? false
                                      : true;
                                  final bool isDisliked = comments1State
                                              .synopseRealtimeVUserArticleComment[
                                                  index]
                                              .articleCommentDislikesAggregate
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
                                      type: 1,
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
                          style: Theme.of(context).textTheme.titleSmall,
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
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_textEditingController.text.isNotEmpty &&
                              userLevel >= 4) {
                            var userComment =
                                BlocProvider.of<UserEventBloc>(context)
                                  ..add(
                                    UserEventCommentSet(
                                      articleGrouppId: widget.articleGroupId,
                                      comment: _textEditingController.text,
                                    ),
                                  );

                            userComment.stream.listen(
                              (state) {
                                if (state.status != UserEventStatus.initial) {
                                  context.push(comments,
                                      extra: widget.articleGroupId);
                                }
                              },
                            );
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
      ),
    );
  }
}
