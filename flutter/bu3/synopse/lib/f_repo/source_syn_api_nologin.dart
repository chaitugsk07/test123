// import 'dart:developer';

import 'package:synopse/core/graphql/graphql_service_nologin.dart';
import 'package:synopse/core/utils/api_response.dart';
import 'package:synopse/f_repo/models/mod_01_language.dart';
import 'package:synopse/f_repo/models/mod_01_onboarding.dart';
import 'package:synopse/f_repo/models/mod_01_signup.dart';
import 'package:synopse/f_repo/models/mod_article_details.dart';
import 'package:synopse/f_repo/models/mod_article_ids.dart';
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
      article_group_id
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
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    response = await service.performQuery(query, variables: variables);
    if (response is Success) {
      final data = response
          .data?['synopse_articles_t_v4_article_groups_l2_detail'] as List;
      // log(" all SUCCESS DATA:${response.data.toString()}");
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

  Future<List<SynopseArticlesTV3ArticleGroupsL2>> getArticleDetailsNo(
    int articleGroupId,
  ) async {
    const String query = '''
    query MyQuery(\$article_group_id: bigint!) {
      synopse_articles_t_v3_article_groups_l2(where: {article_group_id: {_eq: \$article_group_id}}) {
        articles_group
        t_v4_article_groups_l2_detail {
          group_ai_tags_l1
          group_ai_tags_l2
          summary
          article_group_id
          title
          image_urls
          logo_urls
          article_detail_link {
            updated_at_formatted
            likes_count
            comments_count
            views_count
            article_count
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    response = await service.performQuery(query, variables: variables);
    // log(articleGroupId.toString());
    // log('$response $articleGroupId');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v3_article_groups_l2'] as List;
      // log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV3ArticleGroupsL2.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV1Rss1Article>> getArticleIds(
    List articleIds,
  ) async {
    const String query = '''
    query MyQuery(\$article_ids: [bigint!] = null) {
      synopse_articles_t_v1_rss1_articles(where: {article_id: {_in: \$article_ids}}) {
        image_link
        post_link
        title
        t_v1_outlet {
          logo_url
          outlet_display
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_ids": articleIds};
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    response = await service.performQuery(query, variables: variables);
    // log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v1_rss1_articles'] as List;
      // log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesTV1Rss1Article.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<LanguageElement>> getAllLanguage() async {
    const String query = '''
    query MyQuery  @cached {
      synopse_realtime_z_t_json(where: {type: {_eq: "language"}}) {
        json
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    dynamic response;
    response = await service.performQuery(query, variables: variables);
    if (response is Success) {
      final data = response.data?['synopse_realtime_z_t_json'][0]['json']
          ['languages'] as List;
      final searchArticles = data
          .map((dynamic e) =>
              LanguageElement.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<Onboarding>> getOnBoarding(String languageCode) async {
    String query = '''
    query MyQuery  @cached {
      synopse_realtime_z_t_json(where: {type: {_eq: "onboarding_$languageCode"}}) {
        json
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    dynamic response;
    response = await service.performQuery(query, variables: variables);
    if (response is Success) {
      final data = response.data?['synopse_realtime_z_t_json'][0]['json']
          ['onboarding_$languageCode'] as List;
      final searchArticles = data
          .map((dynamic e) => Onboarding.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<Signup>> getSignUp(String languageCode) async {
    String query = '''
    query MyQuery  @cached {
      synopse_realtime_z_t_json(where: {type: {_eq: "signup_$languageCode"}}) {
        json
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    dynamic response;
    response = await service.performQuery(query, variables: variables);
    if (response is Success) {
      final data = response.data?['synopse_realtime_z_t_json'][0]['json']
          ['signup_$languageCode'] as List;
      final searchArticles = data
          .map((dynamic e) => Signup.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }
}
