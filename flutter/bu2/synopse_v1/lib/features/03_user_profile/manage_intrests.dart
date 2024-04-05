import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc_user_intrests/user_intrests_bloc.dart';
import 'package:synopse/features/03_user_profile/widget/manage_intrests_tags.dart';
import 'package:synopse/features/04_home/bloc_root_tags/root_tags_bloc.dart';

class UserIntrests111 extends StatelessWidget {
  const UserIntrests111({super.key});

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Intrests"),
          centerTitle: true, // Add this
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width - 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Personalize your feed by selecting your intrests"),
                BlocBuilder<RootTagsBloc, RootTagsState>(
                  builder: (context, rootTagsState) {
                    if (rootTagsState.status == RootTagsStatus.initial) {
                      return const Center(
                        child: PageLoading(),
                      );
                    } else if (rootTagsState.status == RootTagsStatus.success) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: rootTagsState
                              .synopseArticlesTV4TagsHierarchyRootForYou.length,
                          itemBuilder: (context, index) {
                            final rootTags = rootTagsState
                                    .synopseArticlesTV4TagsHierarchyRootForYou[
                                index];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Animate(
                                  effects: [
                                    FadeEffect(
                                        delay: 350.milliseconds,
                                        duration: 1000.milliseconds)
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Text(
                                      rootTags.tag,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                ),
                                ManageIntrestsTags(
                                  tagId: rootTags.tagId,
                                  userIntrestTags: userIntrestTags,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
