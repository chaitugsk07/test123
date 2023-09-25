import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rss1_v9/core/graphql/graphql_service.dart';
import 'package:rss1_v9/core/utils/router.dart';
import 'package:rss1_v9/features/article_detail/01_model_repo/source_articlerss1_details_api.dart';
import 'package:rss1_v9/features/article_detail/bloc/article_detail_bloc.dart';

class AeticleDetailPage extends StatelessWidget {
  final String postLink;
  final String summary;
  final DateTime postPublished;
  final String logoUrl;
  final String outletDisplay;
  const AeticleDetailPage(
      {super.key,
      required this.postLink,
      required this.summary,
      required this.postPublished,
      required this.logoUrl,
      required this.outletDisplay});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticlesRss1DetailBloc(
        rssFeedServicesDetail: RssFeedServicesDetail(
          GraphQLService(),
        ),
      )..add(ArticlesRss1DetailFetch(postLink)),
      child: ArticleDetail(
        postLink: postLink,
        summary: summary,
        postPublished: postPublished,
        logoUrl: logoUrl,
        outletDisplay: outletDisplay,
      ),
    );
  }
}

class ArticleDetail extends StatefulWidget {
  final String postLink;
  final String summary;
  final DateTime postPublished;
  final String logoUrl;
  final String outletDisplay;
  const ArticleDetail(
      {super.key,
      required this.postLink,
      required this.summary,
      required this.postPublished,
      required this.logoUrl,
      required this.outletDisplay});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  String get _postLink => widget.postLink;
  String get _summary => widget.summary;
  DateTime get _postPublished => widget.postPublished;
  String get _logoUrl => widget.logoUrl;
  String get _outletDisplay => widget.outletDisplay;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 1600,
              minHeight: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    BackButton(
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                BlocBuilder<ArticlesRss1DetailBloc, ArticlesRss1DetailState>(
                  builder: (context, articledetailstate) {
                    if (articledetailstate.status ==
                        ArticlesRss1DetailStatus.initial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (articledetailstate.status ==
                        ArticlesRss1DetailStatus.success) {
                      return Center(
                        child: Column(
                          children: [
                            Text(articledetailstate.rss1ArticlesDetail[0].title,
                                style: Theme.of(context).textTheme.titleLarge),
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.5),
                              thickness: 0.1,
                            ),
                            imagesTitle(articledetailstate, _summary),
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.5),
                              thickness: 0.1,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: articledetailstate
                                  .rss1ArticlesDetail[0].discription.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    articledetailstate.rss1ArticlesDetail[0]
                                        .discription[index],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                );
                              }),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push(webLink, extra: _postLink);
                              },
                              child: buildArticleTile(
                                  articledetailstate
                                      .rss1ArticlesDetail[0].title,
                                  articledetailstate
                                      .rss1ArticlesDetail[0].imageLink[0],
                                  _postPublished,
                                  _outletDisplay,
                                  _logoUrl,
                                  _postLink),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text("Error");
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

  Padding imagesTitle(ArticlesRss1DetailState articlestate, String summary) {
    var constraint = 500.00;
    var width1 = MediaQuery.of(context).size.width;
    var show = "na";
    if (width1 < 500) {
      constraint = width1;
      show = "c";
    } else if (width1 >= 500 && width1 < 700) {
      constraint = 300;
      show = "r";
    } else if (width1 >= 700 && width1 < 1200) {
      constraint = 400;
      show = "r";
    } else if (width1 >= 1200 && width1 < 1600) {
      constraint = 500;
      show = "r";
    } else if (width1 >= 1600) {
      constraint = 500;
      width1 = 1200;
      show = "r";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (show == "r")
                Row(
                  children: [
                    image_1(
                      constraints,
                      constraint,
                      articlestate.rss1ArticlesDetail[0].imageLink[0],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: width1 - constraint - 70,
                      child: Text(
                        summary,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  ],
                ),
              if (show == "c")
                Column(
                  children: [
                    image_1(
                      constraints,
                      constraint,
                      articlestate.rss1ArticlesDetail[0].imageLink[0],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: width1 - 50,
                      child: Text(
                        summary,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  ],
                ),
              Divider(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                thickness: 0.1,
              ),
            ],
          );
        },
      ),
    );
  }

  SizedBox image_1(
      BoxConstraints constraints, double constraint, String image1) {
    return SizedBox(
      width: constraints.constrainWidth(constraint),
      height: constraints.constrainWidth(constraint) * 9 / 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CachedNetworkImage(
          imageUrl: image1,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Center buildArticleTile(
      String title,
      String imageLink,
      DateTime postPublished,
      String outletDisplay,
      String logoUrl,
      String url) {
    //print(state.rss1Articals[index].title);

    String formattedDifference;

    final now = DateTime.now().toUtc();
    final postPublished1 = postPublished.toUtc();
    final difference = now.toUtc().difference(postPublished1);

    if (difference.inMinutes < 60) {
      formattedDifference = '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      formattedDifference = '${difference.inHours}h';
    } else {
      formattedDifference = '${difference.inDays}d';
    }
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: logoUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      outletDisplay,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'Roboto condensed'),
                    ),
                    const SizedBox(width: 10),
                    Text(formattedDifference,
                        style: const TextStyle(
                            fontSize: 8,
                            fontFamily: 'Roboto condensed',
                            color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: imageLink,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
