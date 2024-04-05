import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'dart:math';

import 'package:synopse/core/theme/typography.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/04_home/bloc/user_events/user_event_bloc.dart';

class Comments1Tile extends StatelessWidget {
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
  final bool isOwner;
  final String title;
  final List<String> logoUrls;
  final int type;

  const Comments1Tile(
      {super.key,
      required this.name,
      required this.photoUrl,
      required this.userName,
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
      required this.isOwner,
      required this.title,
      required this.logoUrls,
      required this.type});

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
      child: CommentItemList1(
        name: name,
        userName: userName,
        photoUrl: photoUrl,
        comment: comment,
        articleGroupId: articleGroupId,
        updatedAtFormatted: updatedAtFormatted,
        likesCount: likesCount,
        dislikesCount: dislikesCount,
        isLiked: isLiked,
        isDisliked: isDisliked,
        isEdited: isEdited,
        replyCount: replyCount,
        commentId: commentId,
        account: account,
        isOwner: isOwner,
        title: title,
        logoUrls: logoUrls,
        type: type,
      ),
    );
  }
}

class CommentItemList1 extends StatefulWidget {
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
  final bool isOwner;
  final String title;
  final List<String> logoUrls;
  final int type;

  const CommentItemList1(
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
      required this.isOwner,
      required this.title,
      required this.logoUrls,
      required this.type});

  @override
  State<CommentItemList1> createState() => _CommentItemList1State();
}

class _CommentItemList1State extends State<CommentItemList1> {
  late bool _isLiked;
  late bool _isDisliked;
  late int _likesCount;
  late int _dislikesCount;
  late int randomNumber;
  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isDisliked = widget.isDisliked;
    _likesCount = widget.likesCount;
    _dislikesCount = widget.dislikesCount;

    randomNumber = getRandomNumber();
  }

  void _onUserEventCommentEdit(int commentId, String comment) {
    context.read<UserEventBloc>().add(
          UserEventCommentEdit(
            commentId: commentId,
            comment: comment,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String initials = getInitials(widget.name);
    final List<Color> backgroundColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.brown,
      Colors.lime,
      Colors.amber,
      Colors.grey,
    ];
    final List<Color> textColors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.black,
      Colors.black,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.black,
      Colors.black,
      Colors.black,
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.photoUrl == "na")
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 200.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CircleAvatar(
                      radius: widget.type == 2 ? 15 : 25,
                      backgroundColor: backgroundColors[randomNumber],
                      child: Text(
                        initials,
                        style: MyTypography.t12.copyWith(
                          color: textColors[randomNumber],
                          fontSize: widget.type == 2 ? 10 : 20,
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.photoUrl != "na")
                Animate(
                  effects: [
                    FadeEffect(
                        delay: 200.milliseconds, duration: 1000.milliseconds)
                  ],
                  child: CircleAvatar(
                    radius: widget.type == 2 ? 15 : 25,
                    backgroundImage: NetworkImage(widget.photoUrl),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 85,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push(extUser, extra: widget.account);
                          },
                          child: Text(
                            widget.userName,
                            style: MyTypography.t12.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.isEdited)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Edited',
                              style: MyTypography.t12.copyWith(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (widget.isOwner)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                TextEditingController controller =
                                    TextEditingController(text: widget.comment);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Edit Comment'),
                                      content: Expanded(
                                        child: TextField(
                                          controller: controller,
                                          maxLines: null,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(fontSize: 15),
                                          cursorColor: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.9),
                                          decoration: InputDecoration(
                                            hintText: "Write a comment",
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          onChanged: (value) {
                                            // Handle the text field's value
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.2),
                                            ),
                                            child: Text('Cancel',
                                                style:
                                                    MyTypography.t12.copyWith(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                )),
                                          ),
                                          onPressed: () {
                                            if (context.canPop()) {
                                              context.pop();
                                            } else {
                                              context.push(splash);
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.2),
                                            ),
                                            child: Text('Save',
                                                style:
                                                    MyTypography.t12.copyWith(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                )),
                                          ),
                                          onPressed: () {
                                            if (controller.text !=
                                                widget.comment) {
                                              _onUserEventCommentEdit(
                                                  widget.commentId,
                                                  controller.text);
                                            }
                                            if (context.canPop()) {
                                              context.pop();
                                            } else {
                                              context.push(splash);
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.2),
                                ),
                                child: Text(
                                  'Edit',
                                  style: MyTypography.t12.copyWith(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        widget.comment,
                        style: MyTypography.t12.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4),
                  child: Text(
                    widget.updatedAtFormatted,
                    style: MyTypography.t12.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 5,
                  ),
                ),
                if (widget.replyCount > 0)
                  GestureDetector(
                    onTap: () {
                      if (widget.type == 1 || widget.type == 3) {
                        context.push(
                          commentReply,
                          extra: CommentsReplyOutputData(
                            commentId: widget.commentId,
                            articleGroupId: widget.articleGroupId,
                            account: widget.account,
                            isOwner: widget.isOwner,
                            name: widget.name,
                            userName: widget.userName,
                            photoUrl: widget.photoUrl,
                            comment: widget.comment,
                            updatedAtFormatted: widget.updatedAtFormatted,
                            likesCount: widget.likesCount,
                            dislikesCount: widget.dislikesCount,
                            isLiked: widget.isLiked,
                            isDisliked: widget.isDisliked,
                            isEdited: widget.isEdited,
                            replyCount: widget.replyCount,
                            title: widget.title,
                            logoUrls: widget.logoUrls,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '${widget.replyCount} Replies',
                        style: MyTypography.caption.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                if (widget.replyCount == 0)
                  GestureDetector(
                    onTap: () {
                      if (widget.type == 1 || widget.type == 3) {
                        context.push(
                          commentReply,
                          extra: CommentsReplyOutputData(
                            commentId: widget.commentId,
                            articleGroupId: widget.articleGroupId,
                            account: widget.account,
                            isOwner: widget.isOwner,
                            name: widget.name,
                            userName: widget.userName,
                            photoUrl: widget.photoUrl,
                            comment: widget.comment,
                            updatedAtFormatted: widget.updatedAtFormatted,
                            likesCount: widget.likesCount,
                            dislikesCount: widget.dislikesCount,
                            isLiked: widget.isLiked,
                            isDisliked: widget.isDisliked,
                            isEdited: widget.isEdited,
                            replyCount: widget.replyCount,
                            title: widget.title,
                            logoUrls: widget.logoUrls,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Reply',
                        style: MyTypography.caption.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        if (_isLiked) {
                          context.read<UserEventBloc>().add(
                                UserEventCommentLikeDelete(
                                    commentId: widget.commentId),
                              );
                          _likesCount--;
                        } else {
                          context.read<UserEventBloc>().add(
                                UserEventCommentLike(
                                    commentId: widget.commentId),
                              );
                          _likesCount++;
                        }
                        _isLiked = !_isLiked;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 16,
                    ),
                  ),
                ),
                if (_likesCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '$_likesCount Likes',
                      style: MyTypography.caption.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        if (_isDisliked) {
                          context.read<UserEventBloc>().add(
                                UserEventCommentDislikeDelete(
                                    commentId: widget.commentId),
                              );
                          _dislikesCount--;
                        } else {
                          context.read<UserEventBloc>().add(
                                UserEventCommentDislike(
                                    commentId: widget.commentId),
                              );
                          _dislikesCount++;
                        }
                        _isDisliked = !_isDisliked;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      _isDisliked
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 16,
                    ),
                  ),
                ),
                if (_dislikesCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '$_likesCount Disikes',
                      style: MyTypography.caption.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getInitials(String text) {
    List<String> words = text.split(' ');
    if (words.length > 1) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else {
      return words[0][0].toUpperCase() +
          words[0][words[0].length - 1].toUpperCase();
    }
  }

  int getRandomNumber() {
    var random = Random();
    return random.nextInt(13); // 14 is exclusive
  }
}
