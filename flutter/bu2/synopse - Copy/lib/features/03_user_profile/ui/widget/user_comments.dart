import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/user_comments/user_comments_all_bloc.dart';

class UserComments1 extends StatelessWidget {
  final String photoUrl;
  final String userName;
  final String initials;
  final String account;

  const UserComments1(
      {super.key,
      required this.photoUrl,
      required this.userName,
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
        initials: initials,
        account: account,
      ),
    );
  }
}

class UserComment extends StatefulWidget {
  final String photoUrl;
  final String userName;
  final String initials;
  final String account;

  const UserComment(
      {super.key,
      required this.photoUrl,
      required this.userName,
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
    return BlocBuilder<UserCommentsBloc, UserCommentsState>(
      builder: (context, userCommentsState) {
        if (userCommentsState.status == UserCommentsStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (userCommentsState.status == UserCommentsStatus.success) {
          final s1 = userCommentsState.synopseRealtimeVUserArticleCommentUser;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: s1.length,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.photoUrl == "na")
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 200.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, top: 5),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      backgroundColors[randomNumber],
                                  child: Text(
                                    widget.initials,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: textColors[randomNumber],
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          if (widget.photoUrl != "na")
                            Animate(
                              effects: [
                                FadeEffect(
                                    delay: 200.milliseconds,
                                    duration: 1000.milliseconds)
                              ],
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, top: 5),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(widget.photoUrl),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.left,
                                ),
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.link,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Text(
                                        s1[index].commentToArticleGroup!.title,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  s1[index].comment,
                                ),
                              ],
                            ),
                          ),
                        ],
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
                          thickness: 0.7,
                        ),
                      ),
                    ],
                  ),
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