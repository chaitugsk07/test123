import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/core/utils/image_constant.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc_user_intrests/user_intrests_bloc.dart';
import 'package:synopse/features/03_user_profile/widget/manage_intrests_tags.dart';
import 'package:synopse/features/04_home/bloc_root_tags/root_tags_bloc.dart';

class UserIntrestsSignUp111 extends StatelessWidget {
  const UserIntrestsSignUp111({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RootTagsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserIntrestsTagsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserIntrests(),
    );
  }
}

class UserIntrests extends StatefulWidget {
  const UserIntrests({super.key});

  @override
  State<UserIntrests> createState() => _UserIntrestsState();
}

class _UserIntrestsState extends State<UserIntrests> {
  late List<int> userIntrestTags;
  @override
  void initState() {
    super.initState();
    context.read<RootTagsBloc>().add(RootTagsFetch());
    userIntrestTags = [];
    final userIntrestTagsBloc = BlocProvider.of<UserIntrestsTagsBloc>(context)
      ..add(UserIntrestsTagsFetch());
    userIntrestTagsBloc.stream.listen(
      (state) {
        if (state.status == UserIntrestsTagsStatus.success) {
          for (final item in state.synopseRealtimeTUserTag) {
            userIntrestTags.add(item.tagId);
          }
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              shadowColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: SizedBox(
                height: 300,
                width: 400,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: SvgPicture.asset(
                      SvgConstant.logo,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Do you want to exit the App?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "Are you sure?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: GestureDetector(
                      onTap: () {
                        context.push(splash);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 40,
                        width: 200,
                        child: Text(
                          "No",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.milliseconds, duration: 1000.milliseconds)
                    ],
                    child: GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        );
        return;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Animate(
                effects: [
                  FadeEffect(
                      delay: 100.milliseconds,
                      duration: 1000.milliseconds,
                      curve: Curves.easeInOutCirc),
                ],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: SizedBox(
                      height: 4,
                      width: 300,
                      child: Row(
                        children: [
                          Container(
                            height: 3,
                            width: 98,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Container(
                            height: 3,
                            width: 98,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Container(
                            height: 3,
                            width: 98,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Animate(
                effects: [
                  FadeEffect(
                      delay: 100.milliseconds,
                      duration: 1000.milliseconds,
                      curve: Curves.easeInOutCirc),
                ],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Choose your Favorite Topics: ",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 110,
                  width: MediaQuery.of(context).size.width - 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<RootTagsBloc, RootTagsState>(
                        builder: (context, rootTagsState) {
                          if (rootTagsState.status == RootTagsStatus.initial) {
                            return const Center(
                              child: PageLoading(
                                title: " manage intrests Root Tags",
                              ),
                            );
                          } else if (rootTagsState.status ==
                              RootTagsStatus.success) {
                            return Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: rootTagsState
                                    .synopseArticlesTV4TagsHierarchyRootForYou
                                    .length,
                                itemBuilder: (context, index) {
                                  final rootTags = rootTagsState
                                          .synopseArticlesTV4TagsHierarchyRootForYou[
                                      index];
                                  return Column(
                                    children: [
                                      Animate(
                                        effects: [
                                          FadeEffect(
                                              delay: 350.milliseconds,
                                              duration: 1000.milliseconds)
                                        ],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 10.0),
                                          child: Text(
                                            rootTags.tag,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: ManageIntrestsTags(
                                          tagId: rootTags.tagId,
                                          userIntrestTags: userIntrestTags,
                                        ),
                                      ),
                                      if (index ==
                                          rootTagsState
                                                  .synopseArticlesTV4TagsHierarchyRootForYou
                                                  .length -
                                              1)
                                        const SizedBox(
                                          height: 100,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 1000.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: GestureDetector(
                          onTap: () {
                            context.push(home);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 40,
                            width: 200,
                            child: Text(
                              "Continue",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Animate(
                        effects: [
                          FadeEffect(
                              delay: 1000.milliseconds,
                              duration: 1000.milliseconds)
                        ],
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              height: 50,
                              child: Text(
                                "Back",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
