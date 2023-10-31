import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';
import 'package:synopse_v001/features/05_article_detail/01_model_repo/mod_article_rss_links.dart';

class RssFeedServicesFeedDetails {
  RssFeedServicesFeedDetails(this.service);

  final GraphQLService service;
  Future<List<ArticlesVArticlesMain>> getArticleRssFeed(
    int articleGroupId,
  ) async {
    const String query = '''
    query MyQuery(\$article_group_id: bigint!) {
      articles_v_articles_main(where: {article_group_id: {_eq: \$article_group_id}}) {
        article_group_id
        title
        summary
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
        article_to_group {
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

  Future<String> setLike(int articleGroupId) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!) {
      insert_realtime_t_user_comment_likes_one(object: {article_group_id: \$article_group_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setView(int articleGroupId) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!) {
      insert_realtime_t_user_article_likes_one(object: {article_group_id: \$article_group_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> deleteLike(int articleGroupId) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!) {
      delete_realtime_t_user_article_likes(where: {article_group_id: {_eq: \$article_group_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleComment(int articleGroupId, String comment) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$comment: String!) {
      insert_realtime_t_user_article_comments_one(object: {article_group_id: \$article_group_id, comment: \$comment}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "comment": comment,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleCommentReply(
      int articleGroupId, String comment, int commentId) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$comment: String!, \$comment_id: bigint!) {
      insert_realtime_t_user_article_comments_one(object: {article_group_id: \$article_group_id, comment: \$comment, is_reply: 1, comment_id: \$comment_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "comment": comment,
      "comment_id": commentId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleCommentLike(int commentId) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint!) {
      insert_realtime_t_user_comment_likes_one(object: {comment_id: \$comment_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "comment_id": commentId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> deleteArticleCommentLike(int commentId) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint!) {
      delete_realtime_t_user_comment_likes(where: {comment_id: {_eq: \$comment_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "comment_id": commentId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleCommentDisLike(int commentId) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint!) {
      insert_realtime_t_user_comment_dislikes_one(object: {comment_id: \$comment_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "comment_id": commentId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> deleteArticleCommentDisLike(int commentId) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint!) {
      delete_realtime_t_user_comment_dislikes(where: {comment_id: {_eq: \$comment_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "comment_id": commentId,
    };
    final response = await service.performMutation(query, variables: variables);
    log("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }
}
