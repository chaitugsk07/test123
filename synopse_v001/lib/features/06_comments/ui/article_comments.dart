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
import 'package:synopse_v001/features/06_comments/bloc/article_comments_bloc.dart';
import 'package:synopse_v001/features/06_comments/bloc/article_summarry/article_summary_bloc.dart';
import 'package:synopse_v001/features/06_comments/ui/widgets/article_comment_list.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/article_comments_scaffold_body.dart';
import 'package:synopse_v001/features/06_comments/ui/widgets/comments_scaffold.dart';

class ArticleComments extends StatelessWidget {
  final int articleDetailId;
  const ArticleComments({Key? key, required this.articleDetailId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ArticleSummaryShortBloc>(
            create: (context) => ArticleSummaryShortBloc(
              rssFeedServicesDetailComments: RssFeedServicesDetailComments(
                GraphQLService(),
              ),
            ),
          ),
          BlocProvider<ArticleCommentsBloc>(
            create: (context) => ArticleCommentsBloc(
              rssFeedServicesDetailComments: RssFeedServicesDetailComments(
                GraphQLService(),
              ),
            ),
          ),
        ],
        child: Comments(
          articleDetailId: articleDetailId,
        ));
  }
}

class Comments extends StatefulWidget {
  final int articleDetailId;

  const Comments({super.key, required this.articleDetailId});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late final ScrollController _scrollController;

  final TextEditingController _textEditingController = TextEditingController();
  bool isliked = false;
  bool isviewed = false;
  int commentsCount = 0;
  num likeCount = 0;
  @override
  void initState() {
    super.initState();

    context
        .read<ArticleSummaryShortBloc>()
        .add(ArticleSummaryShortFetch(articleId: widget.articleDetailId));
    context
        .read<ArticleCommentsBloc>()
        .add(ArticleCommentsFetch(articleId: widget.articleDetailId));
    final articleSummaryShortBloc =
        BlocProvider.of<ArticleSummaryShortBloc>(context);
    _scrollController = ScrollController()..addListener(_onScroll);
    articleSummaryShortBloc.stream.listen(
      (state) {
        if (state.status == ArticlesSummaryStatusStatus.success) {
          commentsCount = state.articlesVArticlesMain[0].commentsCount.toInt();
          var likes = state.articlesVArticlesMain[0].articlesLikes;
          if (likes != null) {
            isliked = true;
            likeCount = state.articlesVArticlesMain[0].likesCount + 1;
          } else {
            isliked = false;
            likeCount = state.articlesVArticlesMain[0].likesCount;
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
          .read<ArticleCommentsBloc>()
          .add(ArticleCommentsFetch(articleId: widget.articleDetailId));
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
    return BlocBuilder<ArticleSummaryShortBloc, ArticleSummaryShortState>(
      builder: (context, articleSummaryShortState) {
        if (articleSummaryShortState.status ==
            ArticlesSummaryStatusStatus.initial) {
          return const PageLoading();
        }
        if (articleSummaryShortState.status ==
            ArticlesSummaryStatusStatus.success) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const SAppBar(
              title: 'Comments',
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ArticleShortSummary(
                              articleSummaryShortState:
                                  articleSummaryShortState),
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
                              thickness: 0.1,
                            ),
                          ),
                          BlocBuilder<ArticleCommentsBloc,
                              ArticleCommentsState>(
                            builder: (context, articleCommentsState) {
                              if (articleCommentsState.status ==
                                  ArticlesCommentStatus.initial) {
                                return Center(
                                  child: SpinKitSpinningLines(
                                    color: Colors.teal.shade700,
                                    size: 100,
                                    lineWidth: 3,
                                  ),
                                );
                              }
                              if (articleCommentsState.status ==
                                  ArticlesCommentStatus.success) {
                                return Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      itemCount: articleCommentsState
                                              .hasReachedMax
                                          ? articleCommentsState
                                              .realtimeVUserArticleComment
                                              .length
                                          : articleCommentsState
                                                  .realtimeVUserArticleComment
                                                  .length +
                                              1,
                                      itemBuilder: (context, index) {
                                        bool isCommentLiked = false;
                                        bool isCommentDisLiked = false;
                                        int commentsLikeCount =
                                            articleCommentsState
                                                .realtimeVUserArticleComment[
                                                    index]
                                                .commentsLikeCount
                                                .toInt();
                                        int commentsDisLikeCount =
                                            articleCommentsState
                                                .realtimeVUserArticleComment[
                                                    index]
                                                .commentsDislikeCount
                                                .toInt();
                                        if (articleCommentsState
                                                .realtimeVUserArticleComment[
                                                    index]
                                                .commentToUserLike
                                                .toString() !=
                                            'null') {
                                          isCommentLiked = true;
                                        }
                                        if (articleCommentsState
                                                .realtimeVUserArticleComment[
                                                    index]
                                                .commentToUserDislike
                                                .toString() !=
                                            'null') {
                                          isCommentDisLiked = true;
                                        }
                                        return index >=
                                                articleCommentsState
                                                    .realtimeVUserArticleComment
                                                    .length
                                            ? const ImageShimmer()
                                            : CommentListItem(
                                                account: articleCommentsState
                                                    .realtimeVUserArticleComment[
                                                        index]
                                                    .commentsToUsers!
                                                    .account,
                                                userPhoto: articleCommentsState
                                                    .realtimeVUserArticleComment[
                                                        index]
                                                    .commentsToUsers!
                                                    .userPhoto
                                                    .toInt(),
                                                username: articleCommentsState
                                                    .realtimeVUserArticleComment[
                                                        index]
                                                    .commentsToUsers!
                                                    .username,
                                                commentsReplyCount:
                                                    articleCommentsState
                                                        .realtimeVUserArticleComment[
                                                            index]
                                                        .commentsReplyCount
                                                        .toInt(),
                                                comment: articleCommentsState
                                                    .realtimeVUserArticleComment[
                                                        index]
                                                    .comment,
                                                updatedAtFormatted:
                                                    articleCommentsState
                                                        .realtimeVUserArticleComment[
                                                            index]
                                                        .updatedAtFormatted,
                                                commentsLikeCount:
                                                    commentsLikeCount,
                                                commentsDisLikeCount:
                                                    commentsDisLikeCount,
                                                isCommentLiked: isCommentLiked,
                                                isCommentDisliked:
                                                    isCommentDisLiked,
                                                commentId: articleCommentsState
                                                    .realtimeVUserArticleComment[
                                                        index]
                                                    .id,
                                              );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const HomeErrorView();
                              }
                            },
                          ),
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
                                  ArticleCommentSet(widget.articleDetailId,
                                      _textEditingController.text));
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
            ),
          );
        } else {
          return const HomeErrorView();
        }
      },
    );
  }
}
