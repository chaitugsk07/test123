import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/04_home/01_model_repo/mod_articalsrss1.dart';
import 'package:synopse_v001/features/06_comments/01_model_repo/mod_article_comments.dart';

class RssFeedServicesDetailComments {
  RssFeedServicesDetailComments(this.service);

  final GraphQLService service;
  Future<List<RealtimeVUserArticleComment>> getArticleComment(
    int articleGroupId,
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$article_group_id: bigint!)  {
      realtime_v_user_article_comments(limit: \$limit, offset: \$offset, where: {article_group_id: {_eq: \$article_group_id}, is_reply: {_eq: 0}}) {
        article_group_id
        id
        comment
        comments_dislike_count
        comments_like_count
        comments_reply_count
        updated_at_formatted
        is_edited
        comments_to_users {
          user_photo
          username
        }
        comment_to_user_like {
          comment_id
        }
        comment_to_user_dislike {
          comment_id
        }
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
      final data = response.data?['realtime_v_user_article_comments'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              RealtimeVUserArticleComment.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<List<RealtimeVUserArticleComment>> getArticleCommentRoot(
    int commentId,
  ) async {
    const String query = '''
    query MyQuery(\$commentId: bigint!)  {
      realtime_v_user_article_comments(where: {id: {_eq: \$commentId}}) {
        id
        comment
        comments_dislike_count
        comments_like_count
        comments_reply_count
        updated_at_formatted
        is_edited
        comments_to_users {
          user_photo
          account
          username
        }
        comment_to_user_like {
          comment_id
        }
        comment_to_user_dislike {
          comment_id
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "commentId": commentId,
    };

    final response = await service.performQueryL(query, variables: variables);

    log('$response');
    if (response is Success) {
      final data = response.data?['realtime_v_user_article_comments'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              RealtimeVUserArticleComment.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<List<RealtimeVUserArticleComment>> getArticleCommentReply(
    int commentId,
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$comment_id: bigint!)  {
      realtime_v_user_article_comments(limit: \$limit, offset: \$offset, where: {comment_id: {_eq: \$comment_id}}) {
        id
        comment
        comments_dislike_count
        comments_like_count
        comments_reply_count
        updated_at_formatted
        is_edited
        comments_to_users {
          user_photo
          account
          username
        }
        comment_to_user_like {
          comment_id
        }
        comment_to_user_dislike {
          comment_id
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "comment_id": commentId,
      "offset": offset,
      "limit": limit,
    };

    final response = await service.performQueryL(query, variables: variables);

    log('$response');
    if (response is Success) {
      final data = response.data?['realtime_v_user_article_comments'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) =>
              RealtimeVUserArticleComment.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<List<ArticlesVArticlesMain>> getArticleSummaryShort(
    int articleGroupId,
  ) async {
    const String query = '''
   query MyQuery(\$article_group_id: bigint!) {
      articles_v_articles_main(where: {article_group_id: {_eq: \$article_group_id}}) {
        article_group_id
        title
        summary_60_words
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
}
