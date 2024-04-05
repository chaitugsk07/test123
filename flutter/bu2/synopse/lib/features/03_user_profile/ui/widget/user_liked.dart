import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/feed_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/03_user_profile/bloc/get_all_liked/get_all_liked_bloc.dart';

class UserLikedS extends StatelessWidget {
  final String account;

  const UserLikedS({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllLikedBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: UserLiked(
        account: account,
      ),
    );
  }
}

class UserLiked extends StatefulWidget {
  final String account;

  const UserLiked({super.key, required this.account});

  @override
  State<UserLiked> createState() => _UserLikedState();
}

class _UserLikedState extends State<UserLiked> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context
        .read<GetAllLikedBloc>()
        .add(GetAllLikedFetch(account: widget.account));

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
      context
          .read<GetAllLikedBloc>()
          .add(GetAllLikedFetch(account: widget.account));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllLikedBloc, GetAllLikedState>(
      builder: (context, getAllLikedState) {
        if (getAllLikedState.status == GetAllLikedStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (getAllLikedState.status == GetAllLikedStatus.success) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<GetAllLikedBloc>()
                  .add(GetAllLikedRefresh(account: widget.account));
            },
            color: Colors.grey,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: getAllLikedState
                  .synopseArticlesTV4ArticleGroupsL2Detail.length,
              itemBuilder: (context, index) {
                final searchResult = getAllLikedState
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
