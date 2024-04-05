import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/large_tag_tile.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/04_home/bloc/tag_articles/tag_all_bloc.dart';

class SideScrolling1 extends StatelessWidget {
  final String tag;

  const SideScrolling1({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TagAllBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: SideScrolling(
        tag: tag,
      ),
    );
  }
}

class SideScrolling extends StatefulWidget {
  final String tag;
  const SideScrolling({super.key, required this.tag});

  @override
  State<SideScrolling> createState() => _SideScrollingState();
}

class _SideScrollingState extends State<SideScrolling> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<TagAllBloc>().add(TagAllFetch(tag: widget.tag));

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagAllBloc, TagAllState>(
      builder: (context, tagAllState) {
        if (tagAllState.status == TagAllStatus.initial) {
          return const Center(
            child: PageLoading(),
          );
        } else if (tagAllState.status == TagAllStatus.success) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount:
                  tagAllState.synopseArticlesTV4ArticleGroupsL2Detail.length,
              itemBuilder: (context, index) {
                final searchResult =
                    tagAllState.synopseArticlesTV4ArticleGroupsL2Detail[index];
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
                return LargeTagTileM(
                  images: images,
                  logoUrls: logoUrls,
                  ind: index,
                  articleGroupid: articleGroupId,
                  lastUpdatedat: lastUpdatedat,
                  title: title,
                  likesCount: likescount,
                  commentsCount: commentcount,
                  viewsCount: viewcount,
                  isLiked: isliked,
                  isViewed: isviewed,
                  isCommented: iscommented,
                  articleCount: articlecount,
                  type: 1,
                  hTag: widget.tag,
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
