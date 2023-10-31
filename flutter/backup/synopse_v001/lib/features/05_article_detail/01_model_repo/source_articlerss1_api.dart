import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/mod_article_detail.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/mod_article_rss_links.dart';

class RssFeedServicesFeedDetails {
  RssFeedServicesFeedDetails(this.service);

  final GraphQLService service;
  Future<List<ArticlesTV1ArticalsGroupsL1DetailSummary>> getArticleRssFeed(
    int articleGroupId,
  ) async {
    const String query = '''
    query MyQuery(\$article_group_id: bigint!) {
      articles_t_v1_articals_groups_l1_detail(where: {article_group_id: {_eq: \$article_group_id}}) {
          article_group_id
          image_urls
          logo_urls
          title
          summary
          article_groups_l1_to_likes {
            like_count
          }
          article_groups_l1_to_views {
            view_count
          }
          article_groups_l1_to_comments {
            comment_count
          }
          t_v1_articals_groups_l1_views_likes {
            type
          }
          t_v1_articals_groups_l1 {
            articles_group
          }
        }
      }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
    };

    final response = await service.performQueryL(query, variables: variables);

    log('$response');
    if (response is Success) {
      final data =
          response.data?['articles_t_v1_articals_groups_l1_detail'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => ArticlesTV1ArticalsGroupsL1DetailSummary.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<List<ArticlesTV1Rss1Artical>> getOriginalArticleRssFeed(
    List articleIds,
  ) async {
    const String query = '''
    query MyQuery(\$article_ids: [bigint!]) {
      articles_T_v1_rss1_articals(where: {id: {_in: \$article_ids}}) {
        post_link
        post_published
        title
        image_link
        t_v1_rss1_feed_link {
          t_v1_outlet {
            logo_url
            outlet_display
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_ids": articleIds,
    };

    final response = await service.performQueryL(query, variables: variables);

    log('$response');
    if (response is Success) {
      final data = response.data?['articles_T_v1_rss1_articals'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              ArticlesTV1Rss1Artical.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<String> setLikeOrView(int articleGroupId, int type) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$type: Int!) {
      insert_articles_t_v1_articals_groups_l1_views_likes_one(object: {article_group_id: \$article_group_id, type: \$type}) {
        article_group_id
        type
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "type": type
    };
    final response = await service.performMutation(query, variables: variables);
    print("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> deleteLikeOrView(int articleGroupId, int type) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$type: Int!) {
      delete_articles_t_v1_articals_groups_l1_views_likes(where: {article_group_id: {_eq: \$article_group_id}, type: {_eq: \$type}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "type": type
    };
    final response = await service.performMutation(query, variables: variables);
    print("delete SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }
}
