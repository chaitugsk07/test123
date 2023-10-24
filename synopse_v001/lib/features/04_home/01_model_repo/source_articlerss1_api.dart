import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';

class RssFeedServicesFeed {
  RssFeedServicesFeed(this.service);

  final GraphQLService service;
  Future<List<ArticlesVArticlesMain>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!)  {
      articles_v_articles_main(limit: \$limit, offset: \$offset, order_by: {updated_at: desc}) {
       article_group_id
        title
        logo_urls
        image_urls
        updated_at_formatted
        likes_count
        views_count
        comments_count
        articles_likes {
          article_group_id
          account
        }
        articles_views {
          article_group_id
          account
        }
      }
    }
  ''';
    const String query2 = '''
    query MyQuery(\$offset: Int!, \$limit: Int!)  {
      articles_v_articles_main(limit: \$limit, offset: \$offset, order_by: {updated_at: desc}) {
       article_group_id
        title
        logo_urls
        image_urls
        days_since_updated
        likes_count
        views_count
        comments_count
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQueryL(query, variables: variables);
    } else {
      response = await service.performQuery(query2, variables: variables);
    }
    log('$response');
    if (response is Success) {
      final data = response.data?['articles_v_articles_main'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              ArticlesVArticlesMain.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
