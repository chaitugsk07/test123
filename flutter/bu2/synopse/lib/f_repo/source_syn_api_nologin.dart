import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/utils/api_response.dart';
import 'package:synopse/f_repo/models/mod_getall_nologin.dart';

class RssFeedServicesFeed {
  RssFeedServicesFeed(this.service);

  final GraphQLService service;

  Future<List<SynopseArticlesTV4ArticleGroupsL2DetailNoLogin>> getAllNoLogin(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!) {
    synopse_articles_t_v4_article_groups_l2_detail(order_by: {created_at: desc}, limit: \$limit, offset: \$offset, where: {logo_urls: {_is_null: false}}) {
      title
      image_urls
      logo_urls
      article_detail_link {
        updated_at_formatted
        likes_count
        views_count
        comments_count
        article_count
      }
    }
  }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (!isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response
          .data?['synopse_articles_t_v4_article_groups_l2_detail'] as List;
      log(" all SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesTV4ArticleGroupsL2DetailNoLogin.fromJson(
                  e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }
}
