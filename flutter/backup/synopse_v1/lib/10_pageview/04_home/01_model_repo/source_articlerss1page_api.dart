import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/07_pageview/04_home/01_model_repo/mod_articalsrss1page.dart';

class RssFeedPageView {
  RssFeedPageView(this.service);

  final GraphQLService service;
  Future<List<ArticlesTV1ArticalsGroupsL1DetailPage>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!)  {
      articles_t_v1_articals_groups_l1_detail(limit: \$limit, offset: \$offset, order_by: {updated_at: desc}) {
        article_group_id
        updated_at
        title
        summary_60_words
        logo_urls
        image_urls
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
    };

    dynamic response;
    response = await service.performQueryL(query, variables: variables);
    log('$response');
    if (response is Success) {
      final data =
          response.data?['articles_t_v1_articals_groups_l1_detail'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => ArticlesTV1ArticalsGroupsL1DetailPage.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
