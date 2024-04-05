import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/user_comments/user_comments_all_bloc.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_comment_tile.dart';

class UserComments1 extends StatelessWidget {
  final String photoUrl;
  final String userName;
  final String name;
  final String initials;
  final String account;

  const UserComments1(
      {super.key,
      required this.photoUrl,
      required this.userName,
      required this.name,
      required this.initials,
      required this.account});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCommentsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: UserComment(
        photoUrl: photoUrl,
        userName: userName,
        name: name,
        initials: initials,
        account: account,
      ),
    );
  }
}

class UserComment extends StatefulWidget {
  final String photoUrl;
  final String userName;
  final String name;
  final String initials;
  final String account;

  const UserComment(
      {super.key,
      required this.photoUrl,
      required this.userName,
      required this.name,
      required this.initials,
      required this.account});

  @override
  State<UserComment> createState() => _UserCommentState();
}

class _UserCommentState extends State<UserComment> {
  late int randomNumber;
  @override
  void initState() {
    super.initState();
    context.read<UserCommentsBloc>().add(
          UserCommentsFetch(account: widget.account),
        );
    randomNumber = getRandomNumber();
  }

  int getRandomNumber() {
    var random = Random();
    return random.nextInt(13); // 14 is exclusive
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCommentsBloc, UserCommentsState>(
      builder: (context, userCommentsState) {
        if (userCommentsState.status == UserCommentsStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (userCommentsState.status == UserCommentsStatus.success) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                userCommentsState.synopseRealtimeVUserArticleCommentUser.length,
            itemBuilder: (context, index) {
              final bool isLiked = userCommentsState
                          .synopseRealtimeVUserArticleCommentUser[index]
                          .articleCommentLikesAggregate
                          ?.aggregate
                          ?.count ==
                      0
                  ? false
                  : true;
              final bool isDisliked = userCommentsState
                          .synopseRealtimeVUserArticleCommentUser[index]
                          .articleCommentDislikesAggregate
                          ?.aggregate
                          ?.count ==
                      0
                  ? false
                  : true;
              final bool isEdited = userCommentsState
                          .synopseRealtimeVUserArticleCommentUser[index]
                          .isEdited ==
                      0
                  ? false
                  : true;
              final bool isOwner = userCommentsState
                          .synopseRealtimeVUserArticleCommentUser[index]
                          .account ==
                      widget.account
                  ? true
                  : false;
              return Animate(
                effects: [
                  FadeEffect(
                      delay: 600.milliseconds, duration: 1000.milliseconds)
                ],
                child: UserComments1Tile(
                  userName: widget.userName,
                  name: widget.name,
                  photoUrl: widget.photoUrl,
                  comment: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index].comment,
                  articleGroupId: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index]
                      .articleGroupId,
                  title: userCommentsState
                          .synopseRealtimeVUserArticleCommentUser[index]
                          .commentToArticleGroup
                          ?.title ??
                      "",
                  updatedAtFormatted: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index]
                      .updatedAtFormatted,
                  likesCount: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index]
                      .commentsLikeCount,
                  dislikesCount: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index]
                      .commentsDislikeCount,
                  isLiked: isLiked,
                  isDisliked: isDisliked,
                  isEdited: isEdited,
                  replyCount: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index]
                      .commentsReplyCount,
                  commentId: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index].id,
                  account: userCommentsState
                      .synopseRealtimeVUserArticleCommentUser[index].account,
                  isOwner: isOwner,
                  type: 1,
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
