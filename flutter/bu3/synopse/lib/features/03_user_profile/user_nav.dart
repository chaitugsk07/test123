import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/00_common_widgets/user_events/user_event_bloc.dart';
import 'package:synopse/features/04_home/bloc_tags_hierarchy/tags_hierarchy_bloc.dart';
import 'package:synopse/features/04_home/bloc_user_nav1/user_nav1_bloc.dart';

class UserNav1 extends StatelessWidget {
  final int type;
  const UserNav1({super.key, required this.type});

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
        BlocProvider(
          create: (context) => TagsHierarchyBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserNav1Bloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: UserNav(
        type: type,
      ),
    );
  }
}

class UserNav extends StatefulWidget {
  final int type;
  const UserNav({super.key, required this.type});

  @override
  State<UserNav> createState() => _UserNavState();
}

class _UserNavState extends State<UserNav> {
  late List<List<dynamic>> combinedTabList;
  @override
  void initState() {
    super.initState();
    context.read<UserNav1Bloc>().add(UserNav1Fetch());
    combinedTabList = [];
    final userNav1Bloc = BlocProvider.of<UserNav1Bloc>(context);
    userNav1Bloc.stream.listen(
      (state) {
        if (state.status == UserNav1Status.success) {
          for (final item in state.synopseAuthTAuthUserProfile[0].nav1) {
            combinedTabList
                .add([item.tabItem, item.type, item.index1, item.index2]);
          }
          setState(() {});
        }
      },
    );
    context.read<TagsHierarchyBloc>().add(const TagsHierarchyFetch());
  }

  @override
  Widget build(BuildContext context) {
    void reorderData(int oldindex, int newindex) {
      setState(() {
        if (newindex > oldindex) {
          newindex -= 1;
        }
        final items = combinedTabList.removeAt(oldindex);
        combinedTabList.insert(newindex, items);
      });
    }

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 2, animValue)!;
          return Material(
            elevation: elevation,
            shadowColor: Colors.deepPurple,
            child: child,
          );
        },
        child: child,
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.type == 1) {
                        context.push(home);
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.push(splash);
                        }
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Cancel",
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Navigation",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      List<Map<String, dynamic>> outputList =
                          combinedTabList.map((item) {
                        return {
                          "type": item[1],
                          "index1": item[2],
                          "index2": item[3],
                          "tabItem": item[0],
                        };
                      }).toList();

                      var userNav1 = BlocProvider.of<UserEventBloc>(context)
                        ..add(UserEventNav1(combinedTabs: outputList));

                      if (widget.type != 1) {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.push(home);
                        }
                      } else {
                        userNav1.stream.listen(
                          (state) {
                            if (state.status != UserEventStatus.initial) {
                              context.push(home);
                            }
                          },
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Save",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: BlocBuilder<TagsHierarchyBloc, TagsHierarchyState>(
                        builder: (context, tagsHierarchyState) {
                      if (tagsHierarchyState.status ==
                          TagsHierarchyStatus.initial) {
                        return const Center(
                          child: PageLoading(
                            title: 'Manage Intrests initial',
                          ),
                        );
                      } else if (tagsHierarchyState.status ==
                          TagsHierarchyStatus.success) {
                        return ListView.builder(
                          itemCount: tagsHierarchyState
                              .synopseArticlesTV4TagsHierarchyRoot.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = tagsHierarchyState
                                .synopseArticlesTV4TagsHierarchyRoot[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.grey),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                text:
                                                    'You can change the order of your tabs here. To add more interests for your feed, go to the Interests tab and add more interests. Go to',
                                              ),
                                              TextSpan(
                                                text: ' Manage Interests.',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        context
                                                            .push(userIntrests);
                                                      },
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
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
                                          thickness: 0.7,
                                        ),
                                      ),
                                      ReorderableListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        onReorder: reorderData,
                                        proxyDecorator: proxyDecorator,
                                        children: [
                                          for (final items in combinedTabList)
                                            Card(
                                              color: Colors.transparent,
                                              elevation: 0.0,
                                              key: Key(items[0].toString()),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        combinedTabList
                                                            .remove(items);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      child: FaIcon(
                                                          FontAwesomeIcons
                                                              .circleMinus,
                                                          size: 20,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onBackground),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10, top: 4),
                                                      child: Text(items[0],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20, left: 10),
                                                    child: FaIcon(
                                                        FontAwesomeIcons.bars,
                                                        size: 20,
                                                        color: Colors.grey),
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
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    data.tag,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: data.tagsHierarchy.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index1) {
                                    final data1 = data.tagsHierarchy[index1];
                                    bool isNav = false;
                                    for (final item in combinedTabList) {
                                      if (item[0] == data1.tag) {
                                        isNav = true;
                                      }
                                    }
                                    return (!isNav)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      combinedTabList.add([
                                                        data1.tag,
                                                        1,
                                                        data1.tagId,
                                                        data1.tagHierachy,
                                                      ]);
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .circlePlus,
                                                      size: 20,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data1.tag,
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                )
                                              ],
                                            ),
                                          )
                                        : Container();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
