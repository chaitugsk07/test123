import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';

class RssFeedServicesFeed {
  RssFeedServicesFeed(this.service);

  final GraphQLService service;
  Future<List<ArticlesVArticleGroup>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!) @cached {
      articles_v_article_group(limit: \$limit, offset: \$offset, order_by: {updated_at: desc}) {
        article_group_id
        title
        logo_urls
        image_urls
        view_count
        like_count
        comment_count
        updated_at
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
      final data = response.data?['articles_v_article_group'] as List;
      //print("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              ArticlesVArticleGroup.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
