import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';

class RssFeedServicesFeed {
  RssFeedServicesFeed(this.service);

  final GraphQLService service;
  Future<List<ArticlesTV1ArticalsGroupsL1Detail>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!) @cached {
      articles_t_v1_articals_groups_l1_detail(limit: \$limit, offset: \$offset, order_by: {updated_at: desc}) {
        article_group_id
        title
        logo_urls
        image_urls
        updated_at
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
      }
    }
  ''';
    const String query2 = '''
    query MyQuery(\$offset: Int!, \$limit: Int!) @cached {
      articles_t_v1_articals_groups_l1_detail(limit: \$limit, offset: \$offset, order_by: {updated_at: desc}) {
        article_group_id
        title
        logo_urls
        image_urls
        updated_at
        article_groups_l1_to_likes {
          like_count
        }
        article_groups_l1_to_views {
          view_count
        }
        article_groups_l1_to_comments {
          comment_count
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
    if (isLoggedIn) {
      response = await service.performQueryL(query, variables: variables);
    } else {
      response = await service.performQuery(query2, variables: variables);
    }
    log('$response');
    if (response is Success) {
      final data =
          response.data?['articles_t_v1_articals_groups_l1_detail'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => ArticlesTV1ArticalsGroupsL1Detail.fromJson(
              e as Map<String, dynamic>))
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
    print("SUCCESS DATA:${response.data.toString()}");
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
    print("SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }
}
