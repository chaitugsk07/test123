import 'dart:developer';

import 'package:synopse_v1/core/graphql/graphql_service.dart';
import 'package:synopse_v1/features/article_detail/01_model_repo/mod_articalsrss1_detail.dart';
import 'package:synopse_v1/core/utils/api_response.dart';

class RssFeedServicesDetail {
  RssFeedServicesDetail(this.service);

  final GraphQLService service;
  Future<List<Rss1ArticlesDetail>> getArticleRssAricleDetail(
    String postLink,
  ) async {
    const String query = '''
    query MyQuery(\$post_link: String = "") {
      rss1_articles_detail(where: {post_link: {_eq: \$post_link}}) {
        title
        image_link
        discription
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "post_link": postLink,
    };
    final response = await service.performQuery(query, variables: variables);
    log('$response');
    if (response is Success) {
      final data = response.data?['rss1_articles_detail'] as List;
      //print("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              Rss1ArticlesDetail.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
