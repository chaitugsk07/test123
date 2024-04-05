import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/user_saved/user_saved_all_bloc.dart';
import 'package:synopse/features/03_user_profile/ui/widget/user_saved_widget.dart';

class UserSavedS extends StatelessWidget {
  const UserSavedS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserSavedBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: const UserSaved(),
    );
  }
}

class UserSaved extends StatefulWidget {
  const UserSaved({super.key});

  @override
  State<UserSaved> createState() => _UserSavedState();
}

class _UserSavedState extends State<UserSaved> {
  @override
  void initState() {
    super.initState();
    context.read<UserSavedBloc>().add(UserSavedFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSavedBloc, UserSavedState>(
      builder: (context, userSavedState) {
        if (userSavedState.status == UserSavedStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (userSavedState.status == UserSavedStatus.success) {
          return ListView.builder(
            itemCount:
                userSavedState.synopseRealtimeTUserArticleBookmark.length,
            itemBuilder: (context, index) {
              final userSaved =
                  userSavedState.synopseRealtimeTUserArticleBookmark[index];
              return UserSavedTiles(
                images: userSaved.tV4ArticleGroupsL2Detail!.imageUrls,
                logoUrls: userSaved.tV4ArticleGroupsL2Detail!.logoUrls,
                articleGroupid: userSaved.articleGroupId,
                title: userSaved.tV4ArticleGroupsL2Detail!.title,
                isbookmarked: true,
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
