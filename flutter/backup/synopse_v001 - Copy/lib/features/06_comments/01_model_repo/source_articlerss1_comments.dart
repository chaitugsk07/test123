import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_comments.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_summary_short.dart';

class RssFeedServicesDetailComments {
  RssFeedServicesDetailComments(this.service);

  final GraphQLService service;
  Future<List<ArticlesTV1ArticalsGroupsL1Comment>> getArticleComment(
    int articleGroupId,
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$article_group_id: bigint!) @cached {
      articles_t_v1_articals_groups_l1_comments(limit: \$limit, offset: \$offset, where: {article_group_id: {_eq: \$article_group_id}, is_reply: {_eq: 0}}) {
        article_group_id
        comments
        like
        dislike
        auth1_user {
          username
          user_photo
          account
        }
        updated_at
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "offset": offset,
      "limit": limit,
    };

    final response = await service.performQueryL(query, variables: variables);

    log('$response');
    if (response is Success) {
      final data =
          response.data?['articles_t_v1_articals_groups_l1_comments'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => ArticlesTV1ArticalsGroupsL1Comment.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<List<ArticlesTV1ArticalsGroupsL1DetailSummaryShort>>
      getArticleSummaryShort(
    int articleGroupId,
  ) async {
    const String query = '''
    query MyQuery(\$article_group_id: bigint!) @cached {
      articles_t_v1_articals_groups_l1_detail(where: {article_group_id: {_eq: \$article_group_id}}) {
        article_group_id
        created_at
        logo_urls
        image_urls
        title
        summary_60_words
        article_groups_l1_to_views {
          view_count
        }
        article_groups_l1_to_likes {
          like_count
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
          .map((dynamic e) =>
              ArticlesTV1ArticalsGroupsL1DetailSummaryShort.fromJson(
                  e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<String> setArticleComment(int articleGroupId, String comment1) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$comments: String!) {
      insert_articles_t_v1_articals_groups_l1_comments_one(object: {article_group_id: \$article_group_id, comments: \$comments}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "comments": comment1,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }
}
