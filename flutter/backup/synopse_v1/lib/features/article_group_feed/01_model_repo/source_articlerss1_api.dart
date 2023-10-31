import 'dart:developer';

import 'package:synopse_v1/core/graphql/graphql_service.dart';
import 'package:synopse_v1/core/utils/api_response.dart';

import 'mod_articalsrss1.dart';

class RssFeedServicesGroupFeed {
  RssFeedServicesGroupFeed(this.service);

  final GraphQLService service;
  Future<List<ArticlesTV1ArticalsGroupsL1Detail>> getArticleGroupRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!) @cached {
      articles_t_v1_articals_groups_l1_detail(limit: \$limit, offset: \$offset, order_by: {created_at: desc}) {
        title
        logo_urls
        image_urls
        article_group_id
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
      final data = response.data?['articles_t_v1_articals_groups_l1_detail'] as List;
      //print("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => ArticlesTV1ArticalsGroupsL1Detail.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
