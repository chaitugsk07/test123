import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/05_article_detail/bloc/set_like_view_comment/set_like_view_comment_bloc.dart';
import 'package:synopse_v001/features/06_comments/bloc/article_comments_bloc.dart';

class CommentListItem extends StatefulWidget {
  final int userPhoto;
  final String account;
  final String username;
  final String updatedAtFormatted;
  final String comment;
  final int commentId;
  final int commentsReplyCount;
  final int commentsLikeCount;
  final int commentsDisLikeCount;
  final bool isCommentLiked;
  final bool isCommentDisliked;
  const CommentListItem({
    super.key,
    required this.userPhoto,
    required this.account,
    required this.username,
    required this.comment,
    required this.updatedAtFormatted,
    required this.commentsReplyCount,
    required this.commentsLikeCount,
    required this.commentsDisLikeCount,
    required this.isCommentLiked,
    required this.isCommentDisliked,
    required this.commentId,
  });

  @override
  State<CommentListItem> createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {
  int commentsLikeCount = 0;
  int commentsDisLikeCount = 0;
  bool isCommentLiked = false;
  bool isCommentDisliked = false;
  @override
  void initState() {
    super.initState();
    commentsLikeCount = widget.commentsLikeCount;
    commentsDisLikeCount = widget.commentsDisLikeCount;
    isCommentLiked = widget.isCommentLiked;
    isCommentDisliked = widget.isCommentDisliked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (widget.userPhoto == 1)
            Animate(
              effects: [
                FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
              ],
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://pub-4297a5d1f32d43b4a18134d76942de8d.r2.dev/' +
                          widget.account.toString() +
                          ".jpg",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          if (widget.userPhoto == 0)
            Animate(
              effects: [
                FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
              ],
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: const Text("A")),
            ),
          SizedBox(
            child: Animate(
              effects: [
                FadeEffect(delay: 250.milliseconds, duration: 1000.milliseconds)
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push(extUserProfile, extra: widget.account);
                      },
                      child: Text(
                        widget.username,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.comment,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.updatedAtFormatted,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 2,
                          ),
                        ),
                        if (widget.commentsReplyCount == 0)
                          GestureDetector(
                            onTap: () {
                              context.push(commentReply,
                                  extra: widget.commentId);
                            },
                            child: Text(
                              "reply",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        if (widget.commentsReplyCount > 0)
                          GestureDetector(
                            onTap: () {
                              context.push(commentReply,
                                  extra: widget.commentId);
                            },
                            child: Text(
                              widget.commentsReplyCount.toString() + " replies",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                final bloc =
                                    context.read<SetLikeViewCommentBloc>();
                                if (isCommentLiked) {
                                  commentsLikeCount--;
                                  isCommentLiked = false;
                                  bloc.add(ArticleCommentLikeDelete(
                                      commentId: widget.commentId));
                                } else {
                                  commentsLikeCount++;
                                  isCommentLiked = true;
                                  bloc.add(ArticleCommentLikeSend(
                                      commentId: widget.commentId));
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FaIcon(
                              isCommentLiked
                                  ? FontAwesomeIcons.solidThumbsUp
                                  : FontAwesomeIcons.thumbsUp,
                              size: 14,
                            ),
                          ),
                        ),
                        Text(
                          commentsLikeCount.toString(),
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                final bloc =
                                    context.read<SetLikeViewCommentBloc>();
                                if (isCommentDisliked) {
                                  commentsDisLikeCount--;
                                  isCommentDisliked = false;
                                  bloc.add(ArticleCommentDisLikeDelete(
                                      commentId: widget.commentId));
                                } else {
                                  commentsDisLikeCount++;
                                  isCommentDisliked = true;
                                  bloc.add(ArticleCommentDisLikeSend(
                                      commentId: widget.commentId));
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FaIcon(
                                isCommentDisliked
                                    ? FontAwesomeIcons.solidThumbsDown
                                    : FontAwesomeIcons.thumbsDown,
                                size: 12),
                          ),
                        ),
                        Text(
                          commentsDisLikeCount.toString(),
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
