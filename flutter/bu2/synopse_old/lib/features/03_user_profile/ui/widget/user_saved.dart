import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/get_all_bookmarked/get_all_bookmarked_bloc.dart';

class UserSavedS extends StatelessWidget {
  const UserSavedS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllBookmarkedBloc(
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
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<GetAllBookmarkedBloc>().add(GetAllBookmarkedFetch());

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<GetAllBookmarkedBloc>().add(GetAllBookmarkedFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllBookmarkedBloc, GetAllBookmarkedState>(
      builder: (context, getAllBookmarkedState) {
        if (getAllBookmarkedState.status == GetAllBookmarkedStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (getAllBookmarkedState.status ==
            GetAllBookmarkedStatus.success) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<GetAllBookmarkedBloc>()
                  .add(GetAllBookmarkedRefresh());
            },
            color: Colors.grey,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: getAllBookmarkedState
                  .synopseArticlesTV4ArticleGroupsL2Detail.length,
              itemBuilder: (context, index) {
                final searchResult = getAllBookmarkedState
                    .synopseArticlesTV4ArticleGroupsL2Detail[index];
                final images = searchResult.imageUrls;
                images.shuffle();
                final logoUrls = searchResult.logoUrls;
                logoUrls.shuffle();
                final articleGroupId = searchResult.articleGroupId;
                final lastUpdatedat =
                    searchResult.articleDetailLink!.updatedAtFormatted;
                final title = searchResult.title;
                final likescount = searchResult.articleDetailLink!.likesCount;
                final viewcount = searchResult.articleDetailLink!.viewsCount;
                final commentcount =
                    searchResult.articleDetailLink!.commentsCount;
                final isliked =
                    searchResult.tUserArticleLikesAggregate!.aggregate!.count ==
                            0
                        ? false
                        : true;
                final isviewed =
                    searchResult.tUserArticleViewsAggregate!.aggregate!.count ==
                            0
                        ? false
                        : true;
                final iscommented = searchResult
                            .tUserArticleCommentsAggregate!.aggregate!.count ==
                        0
                    ? false
                    : true;
                final articlecount =
                    searchResult.articleDetailLink!.articleCount;
                String htag = 'na';
                return FeedTileM(
                  ind: index,
                  articleGroupid: articleGroupId,
                  images: images,
                  logoUrls: logoUrls,
                  lastUpdatedat: lastUpdatedat,
                  title: title,
                  likesCount: likescount,
                  viewsCount: viewcount,
                  commentsCount: commentcount,
                  isLiked: isliked,
                  isViewed: isviewed,
                  isCommented: iscommented,
                  articleCount: articlecount,
                  type: 3,
                  hTag: htag,
                  isLoggedin: true,
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}