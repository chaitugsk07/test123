import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/home_error_view.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/loading_effect.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/set_like_view_comment/set_like_view_comment_bloc.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/source_articlerss1_comments.dart';
import 'package:synopse_v001/features/06_comments/bloc/comment_reply/reply_comments_bloc.dart';
import 'package:synopse_v001/features/06_comments/bloc/root_comment/root_comments_bloc.dart';
import 'package:synopse_v001/features/06_comments/ui/widgets/article_comment_list.dart';
import 'package:synopse_v001/features/06_comments/ui/widgets/comments_scaffold.dart';

class CommentsReply extends StatelessWidget {
  final int commentId;
  const CommentsReply({super.key, required this.commentId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RootCommentsBloc>(
            create: (context) => RootCommentsBloc(
              rssFeedServicesDetailComments: RssFeedServicesDetailComments(
                GraphQLService(),
              ),
            ),
          ),
          BlocProvider<ReplyCommentsBloc>(
            create: (context) => ReplyCommentsBloc(
              rssFeedServicesDetailComments: RssFeedServicesDetailComments(
                GraphQLService(),
              ),
            ),
          ),
        ],
        child: CommentReply(
          commentId: commentId,
        ));
  }
}

class CommentReply extends StatefulWidget {
  final int commentId;
  const CommentReply({super.key, required this.commentId});

  @override
  State<CommentReply> createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  late final ScrollController _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  bool isLiked = false;
  bool isDisLiked = false;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RootCommentsBloc>().add(
          RootCommentsFetch(commentId: widget.commentId),
        );

    context.read<ReplyCommentsBloc>().add(
          ReplyCommentsFetch(commentId: widget.commentId),
        );
    final articleSummaryShortBloc = BlocProvider.of<RootCommentsBloc>(context);
    articleSummaryShortBloc.stream.listen(
      (state) {
        if (state.status == RootCommentStatus.success) {
          var likes = state.realtimeVUserArticleComment[0].commentToUserLike;
          var dislikes =
              state.realtimeVUserArticleComment[0].commentToUserDislike;
          if (likes != null) {
            isLiked = true;
          }
          if (dislikes != null) {
            isDisLiked = true;
          }
        }
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context
          .read<ReplyCommentsBloc>()
          .add(ReplyCommentsFetch(commentId: widget.commentId));
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const SAppBar(
        title: 'Reply',
      ),
      body: BlocBuilder<RootCommentsBloc, RootCommentsState>(
        builder: (context, rootCommentsState) {
          if (rootCommentsState.status == RootCommentStatus.initial) {
            return const PageLoading();
          }
          if (rootCommentsState.status == RootCommentStatus.success) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 200.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: CommentListItem(
                              account: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .commentsToUsers!
                                  .account,
                              userPhoto: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .commentsToUsers!
                                  .userPhoto
                                  .toInt(),
                              username: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .commentsToUsers!
                                  .username,
                              commentsReplyCount: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .commentsReplyCount
                                  .toInt(),
                              comment: rootCommentsState
                                  .realtimeVUserArticleComment[0].comment,
                              updatedAtFormatted: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .updatedAtFormatted,
                              commentsLikeCount: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .commentsLikeCount
                                  .toInt(),
                              commentsDisLikeCount: rootCommentsState
                                  .realtimeVUserArticleComment[0]
                                  .commentsDislikeCount
                                  .toInt(),
                              isCommentLiked: isLiked,
                              isCommentDisliked: isDisLiked,
                              commentId: rootCommentsState
                                  .realtimeVUserArticleComment[0].id,
                            ),
                          ),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 350.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.5),
                                thickness: 0.3,
                              ),
                            ),
                          ),
                          BlocBuilder<ReplyCommentsBloc, ReplyCommentsState>(
                            builder: (context, replyCommentsBloc) {
                              if (replyCommentsBloc.status ==
                                  ReplyCommentStatus.initial) {
                                return Center(
                                  child: SpinKitSpinningLines(
                                    color: Colors.teal.shade700,
                                    size: 100,
                                    lineWidth: 3,
                                  ),
                                );
                              }
                              if (replyCommentsBloc.status ==
                                  ReplyCommentStatus.success) {
                                return Container(
                                  padding: const EdgeInsets.only(left: 30),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.1),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        controller: _scrollController,
                                        itemCount: replyCommentsBloc
                                                .hasReachedMax
                                            ? replyCommentsBloc
                                                .realtimeVUserArticleComment
                                                .length
                                            : replyCommentsBloc
                                                    .realtimeVUserArticleComment
                                                    .length +
                                                1,
                                        itemBuilder: (context, index) {
                                          bool isCommentLiked = false;
                                          bool isCommentDisLiked = false;
                                          int commentsLikeCount =
                                              replyCommentsBloc
                                                  .realtimeVUserArticleComment[
                                                      index]
                                                  .commentsLikeCount
                                                  .toInt();
                                          int commentsDisLikeCount =
                                              replyCommentsBloc
                                                  .realtimeVUserArticleComment[
                                                      index]
                                                  .commentsDislikeCount
                                                  .toInt();
                                          if (replyCommentsBloc
                                                  .realtimeVUserArticleComment[
                                                      index]
                                                  .commentToUserLike
                                                  .toString() !=
                                              'null') {
                                            isCommentLiked = true;
                                          }
                                          if (replyCommentsBloc
                                                  .realtimeVUserArticleComment[
                                                      index]
                                                  .commentToUserDislike
                                                  .toString() !=
                                              'null') {
                                            isCommentDisLiked = true;
                                          }
                                          return index >=
                                                  replyCommentsBloc
                                                      .realtimeVUserArticleComment
                                                      .length
                                              ? const ImageShimmer()
                                              : CommentListItem(
                                                  account: replyCommentsBloc
                                                      .realtimeVUserArticleComment[
                                                          index]
                                                      .commentsToUsers!
                                                      .account,
                                                  userPhoto: replyCommentsBloc
                                                      .realtimeVUserArticleComment[
                                                          index]
                                                      .commentsToUsers!
                                                      .userPhoto
                                                      .toInt(),
                                                  username: replyCommentsBloc
                                                      .realtimeVUserArticleComment[
                                                          index]
                                                      .commentsToUsers!
                                                      .username,
                                                  commentsReplyCount:
                                                      replyCommentsBloc
                                                          .realtimeVUserArticleComment[
                                                              index]
                                                          .commentsReplyCount
                                                          .toInt(),
                                                  comment: replyCommentsBloc
                                                      .realtimeVUserArticleComment[
                                                          index]
                                                      .comment,
                                                  updatedAtFormatted:
                                                      replyCommentsBloc
                                                          .realtimeVUserArticleComment[
                                                              index]
                                                          .updatedAtFormatted,
                                                  commentsLikeCount:
                                                      commentsLikeCount,
                                                  commentsDisLikeCount:
                                                      commentsDisLikeCount,
                                                  isCommentLiked:
                                                      isCommentLiked,
                                                  isCommentDisliked:
                                                      isCommentDisLiked,
                                                  commentId: replyCommentsBloc
                                                      .realtimeVUserArticleComment[
                                                          index]
                                                      .id,
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const HomeErrorView();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.faceSmile,
                          size: 20,
                        ),
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
                            if (_textEditingController.text.isNotEmpty) {
                              context.read<SetLikeViewCommentBloc>().add(
                                  ArticleCommentReplySet(
                                      rootCommentsState
                                          .realtimeVUserArticleComment[0]
                                          .articleGroupId,
                                      _textEditingController.text,
                                      widget.commentId));
                              _textEditingController.clear();
                            }
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.paperPlane,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const HomeErrorView();
          }
        },
      ),
    );
  }
}
