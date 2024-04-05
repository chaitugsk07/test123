import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/router.dart';
import 'package:synopse/f_repo/source_syn_api.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:synopse/features/05_article_details/bloc/article_ids/article_ids_bloc.dart';

class ArticleIdS extends StatelessWidget {
  final List articleIds;

  const ArticleIdS({super.key, required this.articleIds});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticleIdsBloc(
            rssFeedServices: RssFeedServicesFeed(
              GraphQLService(),
            ),
          ),
        ),
      ],
      child: ArticleId(
        articleIds: articleIds,
      ),
    );
  }
}

class ArticleId extends StatefulWidget {
  final List articleIds;
  const ArticleId({super.key, required this.articleIds});

  @override
  State<ArticleId> createState() => _ArticleIdState();
}

class _ArticleIdState extends State<ArticleId> {
  @override
  void initState() {
    super.initState();
    context.read<ArticleIdsBloc>().add(
          ArticleIdsFetch(
            articleIds: widget.articleIds,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleIdsBloc, ArticleIdsState>(
      builder: (context, aticleIdsState) {
        if (aticleIdsState.status == ArticleIdsStatus.initial) {
          return const Center(child: PageLoading());
        } else if (aticleIdsState.status == ArticleIdsStatus.success) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 95,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: aticleIdsState.synopseArticlesTV1Rss1Article.length,
              itemBuilder: (context, index) {
                return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.push(detailpage,
                            extra: aticleIdsState
                                .synopseArticlesTV1Rss1Article[index].postLink);
                      },
                      child: Row(
                        children: [
                          ClipOval(
                            child: Builder(
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 30,
                                  child: CachedNetworkImage(
                                    imageUrl: aticleIdsState
                                        .synopseArticlesTV1Rss1Article[index]
                                        .tV1Outlet!
                                        .logoUrl,
                                    placeholder: (context, url) => Center(
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                aticleIdsState
                                    .synopseArticlesTV1Rss1Article[index].title,
                              ),
                            ),
                          ),
                          if (aticleIdsState
                                  .synopseArticlesTV1Rss1Article[index]
                                  .imageLink !=
                              "")
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      try {
                                        return CachedNetworkImage(
                                          imageUrl: aticleIdsState
                                              .synopseArticlesTV1Rss1Article[
                                                  index]
                                              .imageLink,
                                          fit: BoxFit.cover,
                                        );
                                      } catch (e) {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ));
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
