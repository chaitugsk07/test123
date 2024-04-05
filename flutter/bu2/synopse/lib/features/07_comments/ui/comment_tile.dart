import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'dart:math';

import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.photoUrl == "na")
                GestureDetector(
                  onTap: () {
                    context.push(extUserProfile, extra: widget.account);
                  },
                  child: Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: CircleAvatar(
                        radius: widget.type == 2 ? 20 : 15,
                        backgroundColor: backgroundColors[randomNumber],
                        child: Text(
                          initials,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: textColors[randomNumber],
                                    fontWeight: FontWeight.bold,
                                    fontSize: widget.type == 2 ? 20 : 15,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.photoUrl != "na")
                GestureDetector(
                  onTap: () {
                    context.push(extUserProfile, extra: widget.account);
                  },
                  child: Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: CircleAvatar(
                      radius: widget.type == 2 ? 20 : 15,
                      backgroundImage: NetworkImage(widget.photoUrl),
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 85,
                      height: 22,
                      child: Row(
                        children: [
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 200.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: GestureDetector(
                              onTap: () {
                                context.push(extUserProfile,
                                    extra: widget.account);
                              },
                              child: Text(
                                "@${widget.userName}",
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          if (widget.isEdited)
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text('Edited',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontStyle: FontStyle.italic)),
                            ),
                          const Spacer(),
                          if (widget.isOwner)
                            IconButton(
                              onPressed: () {
                                TextEditingController controller =
                                    TextEditingController(text: widget.comment);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Edit Comment',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
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
                                        ElevatedButton(
                                          child: Text(
                                            'Cancel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          onPressed: () {
                                            if (context.canPop()) {
                                              context;
                                            } else {
                                              context.push(splash);
                                            }
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                            'Save',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
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
                              icon: const Icon(
                                Icons.edit,
                                size: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                    child: Text(
                      widget.comment,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4),
                  child: Text(
                    widget.updatedAtFormatted,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                if (widget.replyCount > 0)
                  GestureDetector(
                    onTap: () {
                      context.push(
                        commentsReply,
                        extra: widget.commentId,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '${widget.replyCount} Replies',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                if (widget.replyCount == 0)
                  GestureDetector(
                    onTap: () {
                      context.push(
                        commentsReply,
                        extra: widget.commentId,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Reply',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                if (!widget.isOwner)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.circle,
                      color: Colors.grey,
                      size: 5,
                    ),
                  ),
                if (!widget.isOwner)
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
                        color: Colors.grey,
                        size: 12,
                      ),
                    ),
                  ),
                if (_likesCount > 0 && !widget.isOwner)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '$_likesCount',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                if (_likesCount > 0 && widget.isOwner)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '$_likesCount Likes',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                if (!widget.isOwner)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.circle,
                      color: Colors.grey,
                      size: 5,
                    ),
                  ),
                if (!widget.isOwner)
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
                        color: Colors.grey,
                        size: 12,
                      ),
                    ),
                  ),
                if (_dislikesCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '$_likesCount Disikes',
                    ),
                  ),
              ],
            ),
          ),
          Animate(
            effects: [
              FadeEffect(delay: 350.milliseconds, duration: 1000.milliseconds)
            ],
            child: Divider(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              thickness: 0.3,
            ),
          ),
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
