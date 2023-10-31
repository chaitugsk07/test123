import 'dart:developer';

import 'package:synopse_v1/core/graphql/graphql_service.dart';
import 'package:synopse_v1/features/feed/01_model_repo/mod_articalsrss1.dart';
import 'package:synopse_v1/core/utils/api_response.dart';

class RssFeedServicesFeed {
  RssFeedServicesFeed(this.service);

  final GraphQLService service;
  Future<List<Rss1Artical>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!) @cached {
      rss1_articals(limit: \$limit, offset: \$offset, order_by: {post_published: desc}, where: {is_default_image: {_eq: 1}, is_in_detail: {_eq: 1}}) {
        post_link
        image_link
        title
        summary
        author
        post_published
        is_default_image
        rss1LinkByRss1Link {
          outlet
          rss1_link_name
          rss1_outlet {
            logo_url
            outlet_display
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
    };
    final response = await service.performQuery(query, variables: variables);
    log('$response');
    if (response is Success) {
      final data = response.data?['rss1_articals'] as List;
      //print("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => Rss1Artical.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
