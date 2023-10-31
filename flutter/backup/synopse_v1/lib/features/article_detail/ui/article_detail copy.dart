import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse_v1/core/graphql/graphql_service.dart';
import 'package:synopse_v1/features/article_detail/01_model_repo/source_articlerss1_details_api.dart';
import 'package:synopse_v1/features/article_detail/bloc/article_detail_bloc.dart';

class AeticleDetailPage extends StatelessWidget {
  final String postLink;
  final String summary;
  const AeticleDetailPage(
      {super.key, required this.postLink, required this.summary});

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
      ),
    );
  }
}

class ArticleDetail extends StatefulWidget {
  final String postLink;
  final String summary;
  const ArticleDetail(
      {super.key, required this.postLink, required this.summary});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  String get _postLink => widget.postLink;
  String get _summary => widget.summary;
  int show = 0;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 1600,
          ),
          child: Column(
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
                          Text(screenSize.width.toString()),
                          Text(articledetailstate
                              .rss1ArticlesDetail[0].imageLink.length
                              .toString()),
                          images(articledetailstate),

                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.5),
                            thickness: 0.1,
                          ), //
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
    );
  }

  Padding images(ArticlesRss1DetailState articlestate) {
    var constraint = 500.00;
    var width = MediaQuery.of(context).size.width;
    var count = articlestate.rss1ArticlesDetail[0].imageLink.length;
    if (width < 500) {
      constraint = width - 16;
      show = 1;
    } else if (width > 700 && width < 1000) {
      if (count >= 2) {
        constraint = width / 2 - 16;
        show = 2;
      } else {
        constraint = 500;
        show = 1;
      }
    } else if (width > 1000 && width < 1500) {
      if (count >= 3) {
        constraint = width / 3 - 16;
        show = 3;
      } else if (count == 2) {
        constraint = 500;
        show = 2;
      } else {
        constraint = 500;
        show = 1;
      }
    } else if (width > 1500) {
      if (count == 3) {
        constraint = 500;
        show = 3;
      } else if (count == 2) {
        constraint = 500;
        show = 2;
      } else {
        constraint = 500;
        show = 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (show == 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image_1(constraints, constraint,
                        articlestate.rss1ArticlesDetail[0].imageLink[0]),
                  ],
                ),
              if (show == 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image_1(constraints, constraint,
                        articlestate.rss1ArticlesDetail[0].imageLink[0]),
                    const SizedBox(width: 8),
                    image_1(constraints, constraint,
                        articlestate.rss1ArticlesDetail[0].imageLink[1]),
                  ],
                ),
              if (show == 3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image_1(constraints, constraint,
                        articlestate.rss1ArticlesDetail[0].imageLink[0]),
                    const SizedBox(width: 8),
                    image_1(constraints, constraint,
                        articlestate.rss1ArticlesDetail[0].imageLink[1]),
                    const SizedBox(width: 8),
                    image_1(constraints, constraint,
                        articlestate.rss1ArticlesDetail[0].imageLink[2]),
                  ],
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
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          image1,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
