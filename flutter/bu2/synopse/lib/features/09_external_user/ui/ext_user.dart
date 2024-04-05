import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_imp_tiles.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_comments.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_liked.dart';
import 'package:synopse/features/09_external_user/bloc/ext_user_follow/ext_user_follow_bloc.dart';
import 'package:synopse/features/09_external_user/bloc/ext_user_metadata/ext_user_bloc.dart';
import 'package:synopse/features/09_external_user/ui/widget/ext_user_follow.dart';

class ExtUser1 extends StatelessWidget {
  final String account;
  const ExtUser1({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExtUserBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ExtUserFollowBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ExtUser(
        extAccount: account,
      ),
    );
  }
}

class ExtUser extends StatefulWidget {
  final String extAccount;
  const ExtUser({super.key, required this.extAccount});

  @override
  State<ExtUser> createState() => _ExtUserState();
}

class _ExtUserState extends State<ExtUser> {
  late int randomNumber;
  late String account;
  @override
  void initState() {
    super.initState();
    context.read<ExtUserBloc>().add(ExtUserFetch(account: widget.extAccount));

    _getAccountFromSharedPreferences();

    randomNumber = getRandomNumber();
  }

  _getAccountFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        account = prefs.getString('account') ?? '';
        if (account != widget.extAccount) {
          context.read<ExtUserFollowBloc>().add(
                ExtUserFollowFetch(account: widget.extAccount),
              );
        }
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.push(splash);
            }
          },
        ),
        title: const Text('User'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ExtUserBloc, ExtUserState>(
          builder: (context, extUserState) {
            if (extUserState.status == ExtUserStatus.initial) {
              return const Center(
                child: PageLoading(),
              );
            } else if (extUserState.status == ExtUserStatus.success) {
              final String initials = getInitials(extUserState
                  .synopseRealtimeVUserMetadatum[0]
                  .userToLevel!
                  .userToLink!
                  .name);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                extUserState.synopseRealtimeVUserMetadatum[0]
                                    .userToLevel!.userToLink!.username,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 5),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text(
                                      extUserState
                                          .synopseRealtimeVUserMetadatum[0]
                                          .userToLevel!
                                          .userLevelLink!
                                          .levelName,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Text('Reputation'),
                            Text(
                              extUserState.synopseRealtimeVUserMetadatum[0]
                                  .userReputation
                                  .toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.photourl ==
                            "na")
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 200.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20, top: 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: backgroundColors[randomNumber],
                                child: Text(
                                  initials,
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
                        if (extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.photourl !=
                            "na")
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 200.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10, top: 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(extUserState
                                    .synopseRealtimeVUserMetadatum[0]
                                    .userToLevel!
                                    .userToLink!
                                    .photourl),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (extUserState.synopseRealtimeVUserMetadatum[0]
                            .userToLevel!.userToLink!.bio !=
                        "")
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            extUserState.synopseRealtimeVUserMetadatum[0]
                                .userToLevel!.userToLink!.bio,
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                        thickness: 0.4,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 60,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              UserImpTile1(
                                t1Number: extUserState
                                    .synopseRealtimeVUserMetadatum[0]
                                    .userFollowing
                                    .toString(),
                                t1Text: "Following",
                              ),
                              UserImpTile1(
                                t1Number: extUserState
                                    .synopseRealtimeVUserMetadatum[0]
                                    .userFollowers
                                    .toString(),
                                t1Text: "Followers",
                              ),
                              if (account != widget.extAccount)
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 600.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: BlocBuilder<ExtUserFollowBloc,
                                      ExtUserFollowState>(
                                    builder: (context, extUserFollowState) {
                                      if (extUserFollowState.status ==
                                          ExtUserFollowStatus.initial) {
                                        return const Center(
                                          child: PageLoading(),
                                        );
                                      } else if (extUserFollowState.status ==
                                          ExtUserFollowStatus.success) {
                                        return Following1(
                                          isFollowing: extUserFollowState
                                                      .followingCount ==
                                                  0
                                              ? true
                                              : false,
                                          account: widget.extAccount,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        )),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabAlignment: TabAlignment.fill,
                            //isScrollable: true,
                            indicator: const BoxDecoration(), // Add this line
                            labelColor:
                                Theme.of(context).colorScheme.onBackground,
                            unselectedLabelColor: Colors.grey,
                            dividerColor: Colors.grey,
                            tabs: const [
                              Tab(
                                child: Text("Likes"),
                              ),
                              Tab(
                                child: Text("Comments"),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 135,
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UserLikedS(
                                    account: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .account,
                                  ),
                                ),
                                Center(
                                  child: UserComments1(
                                    photoUrl: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .userToLevel!
                                        .userToLink!
                                        .photourl,
                                    userName: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .userToLevel!
                                        .userToLink!
                                        .username,
                                    name: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .userToLevel!
                                        .userToLink!
                                        .name,
                                    initials: initials,
                                    account: extUserState
                                        .synopseRealtimeVUserMetadatum[0]
                                        .account,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
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
