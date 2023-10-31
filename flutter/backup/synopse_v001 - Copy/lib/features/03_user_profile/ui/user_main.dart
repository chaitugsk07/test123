import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/router.dart';
import 'package:synopse_v001/features/03_user_profile/01_models_repo/source_user_profile_api.dart';
import 'package:synopse_v001/features/03_user_profile/bloc/user_counts/user_counts_bloc.dart';
import 'package:synopse_v001/features/03_user_profile/bloc/user_profile_bloc.dart';

class UserMain extends StatelessWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc(
            userProfileService: UserProfileService(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider<UserCountsBloc>(
          create: (context) => UserCountsBloc(
            userProfileService: UserProfileService(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserAllData(),
    );
  }
}

class UserAllData extends StatefulWidget {
  const UserAllData({Key? key}) : super(key: key);

  @override
  State<UserAllData> createState() => _UserAllDataState();
}

class _UserAllDataState extends State<UserAllData> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(const UserProfileGet());
    final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.stream.listen((state) {
      if (state.status == UserProfileStatus.success) {
        context.read<UserCountsBloc>().add(
            UserCountGet(userId: state.authAuth1User[0].account.toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Animate(
          effects: [
            FadeEffect(delay: 100.milliseconds, duration: 1000.milliseconds)
          ],
          child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Animate(
            effects: [
              FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
            ],
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Handle share button press
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userProfileState) {
          if (userProfileState.status == UserProfileStatus.initial) {
            return Scaffold(
              body: Center(
                child: SpinKitSpinningLines(
                  color: Colors.teal.shade700,
                  size: 200,
                  lineWidth: 3,
                ),
              ),
            );
          } else if (userProfileState.status == UserProfileStatus.success) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(user);
                      },
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 300.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                      userProfileState
                                          .authAuth1User[0].username,
                                      softWrap: true,
                                      maxLines: 4,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 20)),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Animate(
                                effects: [
                                  FadeEffect(
                                      delay: 400.milliseconds,
                                      duration: 1000.milliseconds)
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 190,
                                    height: 60,
                                    child: SingleChildScrollView(
                                      child: Text(
                                          userProfileState.authAuth1User[0].bio,
                                          softWrap: true,
                                          maxLines: 10,
                                          overflow: TextOverflow.fade,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.7),
                                                  fontSize: 15)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Animate(
                            effects: [
                              FadeEffect(
                                  delay: 100.milliseconds,
                                  duration: 1000.milliseconds)
                            ],
                            child: DottedBorder(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.5),
                              strokeWidth: 1,
                              borderType: BorderType.Circle,
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Stack(
                                    children: [
                                      if (userProfileState
                                              .authAuth1User[0].userPhoto ==
                                          1)
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                'https://pub-4297a5d1f32d43b4a18134d76942de8d.r2.dev/' +
                                                    userProfileState
                                                        .authAuth1User[0]
                                                        .account
                                                        .toString() +
                                                    ".jpg",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      if (userProfileState
                                              .authAuth1User[0].userPhoto ==
                                          0)
                                        FaIcon(
                                          FontAwesomeIcons.userPlus,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 25,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<UserCountsBloc, UserCountsState>(
                      builder: (context, userCountsState) {
                        if (userCountsState.status ==
                            UserCountsStatus.initial) {
                          return SpinKitSpinningLines(
                            color: Colors.teal.shade700,
                            lineWidth: 3,
                          );
                        } else if (userCountsState.status ==
                            UserCountsStatus.success) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Tile1(
                                    count1: userCountsState.userCounts[0].views
                                        .toInt(),
                                    text1: "views",
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Tile1(
                                    count1: userCountsState.userCounts[0].likes
                                        .toInt(),
                                    text1: "Likes",
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Tile1(
                                    count1: userCountsState
                                        .userCounts[0].followers
                                        .toInt(),
                                    text1: "Followers",
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Tile1(
                                    count1: userCountsState
                                        .userCounts[0].following
                                        .toInt(),
                                    text1: "Following",
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DefaultTabController(
                                length: 5,
                                child: Column(
                                  children: [
                                    TabBar(
                                      isScrollable: true,
                                      indicatorColor: Colors.teal.shade700,
                                      labelColor: Colors.teal.shade700,
                                      unselectedLabelColor: Colors.grey,
                                      tabs: const [
                                        Tab(
                                          child: Text("Posts"),
                                        ),
                                        Tab(
                                          child: Text("Read Later"),
                                        ),
                                        Tab(
                                          child: Text("Likes"),
                                        ),
                                        Tab(
                                          child: Text("Views"),
                                        ),
                                        Tab(
                                          child: Text("Comments"),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 200,
                                      child: TabBarView(
                                        children: [
                                          Container(
                                            child: const Center(
                                              child: Text("Followers"),
                                            ),
                                          ),
                                          Container(
                                            child: const Center(
                                              child: Text("Following"),
                                            ),
                                          ),
                                          Container(
                                            child: const Center(
                                              child: Text("Followers"),
                                            ),
                                          ),
                                          Container(
                                            child: const Center(
                                              child: Text("Following"),
                                            ),
                                          ),
                                          Container(
                                            child: const Center(
                                              child: Text("Followers"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                            ),
                          );
                          Navigator.pop(context);
                          return const Scaffold(
                            body: Center(
                              child: SpinKitSpinningLines(
                                color: Colors.deepPurpleAccent,
                                size: 200,
                                lineWidth: 3,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Something went wrong"),
              ),
            );
            Navigator.pop(context);
            return const Scaffold(
              body: Center(
                child: SpinKitSpinningLines(
                  color: Colors.deepPurpleAccent,
                  lineWidth: 3,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class Tile1 extends StatelessWidget {
  final int count1;
  final String text1;

  const Tile1({
    Key? key,
    required this.count1,
    required this.text1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(delay: 600.milliseconds, duration: 1000.milliseconds)
      ],
      child: SizedBox(
        width: 65,
        height: 50,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                ),
            children: [
              TextSpan(text: count1.toString()),
              const TextSpan(text: "\n"),
              TextSpan(
                text: text1,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
