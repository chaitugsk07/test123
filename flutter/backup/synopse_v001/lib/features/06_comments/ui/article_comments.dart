import 'package:cached_network_image/cached_network_image.dart';
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
          var isLikedOrViewed = state
              .articlesTV1ArticalsGroupsL1DetailSummaryShort[0]
              .tV1ArticalsGroupsL1ViewsLikes;
          var comments = state.articlesTV1ArticalsGroupsL1DetailSummaryShort[0]
              .articleGroupsL1ToComments;

          if (comments != null) {
            commentsCount = comments.commentCount.toInt();
          }
          if (isLikedOrViewed != []) {
            for (var i in isLikedOrViewed) {
              setState(
                () {
                  if (i.type == 1) {
                    isliked = true;
                    likeCount = state
                            .articlesTV1ArticalsGroupsL1DetailSummaryShort[0]
                            .articleGroupsL1ToLikes!
                            .likeCount +
                        1;
                  } else if (i.type == 0) {
                    isviewed = true;
                    likeCount = state
                        .articlesTV1ArticalsGroupsL1DetailSummaryShort[0]
                        .articleGroupsL1ToLikes!
                        .likeCount;
                  }
                },
              );
            }
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
            appBar: AppBar(
              leading: Animate(
                effects: [
                  FadeEffect(
                      delay: 100.milliseconds, duration: 1000.milliseconds)
                ],
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              ),
              title: Center(
                child: Animate(
                  effects: [
                    FadeEffect(
                        delay: 200.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Text(
                    'Comments',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 20),
                  ),
                ),
              ),
              actions: [
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 100.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info_rounded,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 25,
                              width: MediaQuery.of(context).size.width - 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: articleSummaryShortState
                                    .articlesTV1ArticalsGroupsL1DetailSummaryShort[
                                        0]
                                    .logoUrls
                                    .length,
                                itemBuilder: (context, index) {
                                  final url = articleSummaryShortState
                                      .articlesTV1ArticalsGroupsL1DetailSummaryShort[
                                          0]
                                      .logoUrls[index];
                                  return Animate(
                                    effects: [
                                      FadeEffect(
                                          delay: 200.milliseconds,
                                          duration: 1000.milliseconds)
                                    ],
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: url,
                                          placeholder: (context, url) =>
                                              const ImageShimmer(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 300.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                textAlign: TextAlign.center,
                                articleSummaryShortState
                                    .articlesTV1ArticalsGroupsL1DetailSummaryShort[
                                        0]
                                    .title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Animate(
                              effects: [
                                FadeEffect(
                                    delay: 300.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: CachedNetworkImage(
                                imageUrl: articleSummaryShortState
                                    .articlesTV1ArticalsGroupsL1DetailSummaryShort[
                                        0]
                                    .imageUrls[0],
                                placeholder: (context, url) =>
                                    const ImageShimmer(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 300.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.start,
                        articleSummaryShortState
                            .articlesTV1ArticalsGroupsL1DetailSummaryShort[0]
                            .summary60Words,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 12, height: 1.5, wordSpacing: 2),
                      ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 400.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final bloc =
                                  context.read<SetLikeViewCommentBloc>();
                              if (isliked) {
                                likeCount = likeCount - 1;

                                bloc.add(SetLikeViewCommentEventSetLike(
                                    action: 'DeleteLike',
                                    articleGroupId: widget.articleDetailId));
                              } else {
                                bloc.add(SetLikeViewCommentEventSetLike(
                                    action: 'InsertLike',
                                    articleGroupId: widget.articleDetailId));
                                likeCount = likeCount + 1;
                              }
                              isliked = !isliked;
                            });
                          },
                          child: isliked
                              ? const FaIcon(
                                  FontAwesomeIcons.solidHeart,
                                  size: 15,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: 15,
                                ),
                        ),
                        if (likeCount != 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              likeCount.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 15),
                            ),
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.comment,
                          size: 15,
                        ),
                        if (commentsCount != 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              commentsCount.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 15),
                            ),
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.eye,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            articleSummaryShortState
                                .articlesTV1ArticalsGroupsL1DetailSummaryShort[
                                    0]
                                .articleGroupsL1ToViews!
                                .viewCount
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 350.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      thickness: 0.1,
                    ),
                  ),
                  BlocBuilder<ArticleCommentsBloc, ArticleCommentsState>(
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
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: articleCommentsState.hasReachedMax
                                ? articleCommentsState
                                    .articlesTV1ArticalsGroupsL1Comment.length
                                : articleCommentsState
                                        .articlesTV1ArticalsGroupsL1Comment
                                        .length +
                                    1,
                            itemBuilder: (context, index) {
                              return index >=
                                      articleCommentsState
                                          .articlesTV1ArticalsGroupsL1Comment
                                          .length
                                  ? const ImageShimmer()
                                  : Row(
                                      children: [
                                        if (articleCommentsState
                                                .articlesTV1ArticalsGroupsL1Comment[
                                                    index]
                                                .auth1User
                                                ?.userPhoto ==
                                            1)
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  'https://pub-4297a5d1f32d43b4a18134d76942de8d.r2.dev/' +
                                                      articleCommentsState
                                                          .articlesTV1ArticalsGroupsL1Comment[
                                                              index]
                                                          .auth1User!
                                                          .account
                                                          .toString() +
                                                      ".jpg",
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        if (articleCommentsState
                                                .articlesTV1ArticalsGroupsL1Comment[
                                                    index]
                                                .auth1User
                                                ?.userPhoto ==
                                            0)
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            child: Container(
                                              child: Image(
                                                image: NetworkImage(
                                                  'https://pub-4297a5d1f32d43b4a18134d76942de8d.r2.dev/' +
                                                      articleCommentsState
                                                          .articlesTV1ArticalsGroupsL1Comment[
                                                              index]
                                                          .auth1User!
                                                          .account
                                                          .toString() +
                                                      ".jpg",
                                                ),
                                              ),
                                            ),
                                          ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                articleCommentsState
                                                    .articlesTV1ArticalsGroupsL1Comment[
                                                        index]
                                                    .auth1User!
                                                    .username,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(fontSize: 10),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                articleCommentsState
                                                    .articlesTV1ArticalsGroupsL1Comment[
                                                        index]
                                                    .comments,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Column(
                                          children: [
                                            Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.thumbsUp,
                                                  size: 10,
                                                ),
                                                Text(
                                                  ' 0',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                FaIcon(
                                                    FontAwesomeIcons.thumbsDown,
                                                    size: 8),
                                                Text(
                                                  ' 0',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    );
                            },
                          ),
                        );
                      } else {
                        return const HomeErrorView();
                      }
                    },
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
