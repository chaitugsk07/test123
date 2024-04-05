import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/graphql/graphql_service.dart';
import 'package:synopse/core/utils/api_response.dart';
import 'package:synopse/f_repo/models/mod_article_bookmarked.dart';
import 'package:synopse/f_repo/models/mod_article_details.dart';
import 'package:synopse/f_repo/models/mod_article_ids.dart';
import 'package:synopse/f_repo/models/mod_article_publisher.dart';
import 'package:synopse/f_repo/models/mod_article_publishers_main.dart';
import 'package:synopse/f_repo/models/mod_comments.dart';
import 'package:synopse/f_repo/models/mod_get4_outlets.dart';
import 'package:synopse/f_repo/models/mod_getall.dart';
import 'package:synopse/f_repo/models/mod_level_info.dart';
import 'package:synopse/f_repo/models/mod_profile_comments.dart';
import 'package:synopse/f_repo/models/mod_search_last3.dart';
import 'package:synopse/f_repo/models/mod_search_results.dart';
import 'package:synopse/f_repo/models/mod_search_with_text.dart';
import 'package:synopse/f_repo/models/mod_search_with_text_last3.dart';
import 'package:synopse/f_repo/models/mod_tag_hierarchy.dart';
import 'package:synopse/f_repo/models/mod_tag_root.dart';
import 'package:synopse/f_repo/models/mod_tag_tree.dart';
import 'package:synopse/f_repo/models/mod_user.dart';
import 'package:synopse/f_repo/models/mod_user_intrest_tags.dart';
import 'package:synopse/f_repo/models/mod_user_intrests.dart';
import 'package:synopse/f_repo/models/mod_user_level.dart';
import 'package:synopse/f_repo/models/mod_user_nav1.dart';

class RssFeedServicesFeed {
  RssFeedServicesFeed(this.service);

  final GraphQLService service;

  Future<List<SynopseArticlesFGetSearchArticleGroup>> getArticleSearch(
    int limit,
    int offset,
    int pSearchId,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$p_searchid: bigint!) {
      synopse_articles_f_get_search_article_group(args: {p_searchid: \$p_searchid}, limit: \$limit, offset: \$offset) {
        article_group_id
        t_v4_article_groups_l2_detail {
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
          t_user_article_comments_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_likes_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_views_aggregate {
            aggregate {
              count
            }
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "p_searchid": pSearchId,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_f_get_search_article_group'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesFGetSearchArticleGroup.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesVArticlesGroupDetailsSearch>>
      getArticleSearchWithText(
    int limit,
    int offset,
    String search,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$search: String!) {
      synopse_articles_v_articles_group_details_search(where: {title_summary: {_iregex: \$search}}, limit: \$limit, offset: \$offset) {
        article_group_id
        article_group {
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
          t_user_article_comments_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_likes_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_views_aggregate {
            aggregate {
              count
            }
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "search": search,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data = response
          .data?['synopse_articles_v_articles_group_details_search'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesVArticlesGroupDetailsSearch.fromJson(
                  e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesFGetSearchArticleGroup>> getUserSearch(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$account1: uuid!, \$limit: Int!, \$offset: Int!) {
      synopse_articles_f_v5_user_groups_vectors(args: {account1: \$account1}, limit: \$limit, offset: \$offset, where: {t_v4_article_groups_l2_detail: {t_user_article_views_aggregate: {count: {predicate: {_eq: 0}}}}}) {
        article_group_id
        t_v4_article_groups_l2_detail {
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
          t_user_article_comments_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_likes_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_views_aggregate {
            aggregate {
              count
            }
          }
        }
      }
    }
  ''';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String account = prefs.getString('account') ?? "";
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "account1": account,
    };
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_f_v5_user_groups_vectors'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesFGetSearchArticleGroup.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4ArticleGroupsL2Detail>> getAll(
    int limit,
    int offset,
    int views,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$views: Int!) {
      synopse_articles_t_v4_article_groups_l2_detail(order_by: {created_at: desc}, limit: \$limit, offset: \$offset, where: {logo_urls: {_is_null: false}, t_user_article_views_aggregate: {count: {predicate: {_eq: \$views}}}}) {
        title
        image_urls
        logo_urls
        article_group_id
        article_detail_link {
          updated_at_formatted
          likes_count
          comments_count
          views_count
          article_count
        }
        t_user_article_comments_aggregate {
          aggregate {
            count
          }
        }
        t_user_article_likes_aggregate {
          aggregate {
            count
          }
        }
        t_user_article_views_aggregate {
          aggregate {
            count
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "views": views,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response
          .data?['synopse_articles_t_v4_article_groups_l2_detail'] as List;
      //log(" all SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV4ArticleGroupsL2Detail.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4ArticleGroupsL2Detail>> getAllLiked(
    int limit,
    int offset,
    String account,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$account: uuid!) {
      synopse_articles_t_v4_article_groups_l2_detail(order_by: {created_at: desc}, limit: \$limit, offset: \$offset, where: {logo_urls: {_is_null: false}, ext_user_likes: {account: {_eq: \$account}}}) {
        title
        image_urls
        logo_urls
        article_group_id
        article_detail_link {
          updated_at_formatted
          likes_count
          comments_count
          views_count
          article_count
        }
        t_user_article_comments_aggregate {
          aggregate {
            count
          }
        }
        t_user_article_likes_aggregate {
          aggregate {
            count
          }
        }
        t_user_article_views_aggregate {
          aggregate {
            count
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "account": account,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response
          .data?['synopse_articles_t_v4_article_groups_l2_detail'] as List;
      //log(" all SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV4ArticleGroupsL2Detail.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4ArticleGroupsL2Detail>> getAllBookmarked(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!) {
      synopse_articles_t_v4_article_groups_l2_detail(order_by: {created_at: desc}, limit: \$limit, offset: \$offset, where: {logo_urls: {_is_null: false}, t_user_article_bookmarks_aggregate: {count: {predicate: {_eq: 1}}}}) {
        title
        image_urls
        logo_urls
        article_group_id
        article_detail_link {
          updated_at_formatted
          likes_count
          comments_count
          views_count
          article_count
        }
        t_user_article_comments_aggregate {
          aggregate {
            count
          }
        }
        t_user_article_likes_aggregate {
          aggregate {
            count
          }
        }
        t_user_article_views_aggregate {
          aggregate {
            count
          }
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
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response
          .data?['synopse_articles_t_v4_article_groups_l2_detail'] as List;
      //log(" all SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV4ArticleGroupsL2Detail.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4ArticleGroupsL2Detail>> gettagAll(
    int limit,
    int offset,
    String tag,
  ) async {
    const String query = '''
    query MyQuery(\$ai_tags: [String!]!, \$limit: Int!, \$offset: Int!) {
      synopse_articles_t_v4_article_groups_l2_detail(order_by: {created_at: desc}, where: {ai_tags: {_contains: \$ai_tags}, image_urls: {_neq: []}}, limit: \$limit, offset: \$offset) {
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
      t_user_article_comments_aggregate {
        aggregate {
          count
        }
      }
      t_user_article_likes_aggregate {
        aggregate {
          count
        }
      }
      t_user_article_views_aggregate {
        aggregate {
          count
        }
      }
    }
  }

  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "ai_tags": [tag],
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response
          .data?['synopse_articles_t_v4_article_groups_l2_detail'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV4ArticleGroupsL2Detail.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeTTempUserSearch>> getArticleSearchLast3() async {
    const String query = '''
    query MyQuery {
      synopse_realtime_t_temp_user_search(limit: 3, order_by: {id: desc}) {
        search
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_t_temp_user_search'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeTTempUserSearch.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeTTempUserSearchWithText>>
      getArticleSearchLast3WithText() async {
    const String query = '''
    query MyQuery {
      synopse_realtime_t_temp_user_search_with_text(limit: 3, order_by: {updated_at: desc}) {
        text
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response
          .data?['synopse_realtime_t_temp_user_search_with_text'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeTTempUserSearchWithText.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<String> getUserVector() async {
    const String query = '''
    query MyQuery {
      synopse_auth_t_auth_user_profile {
        is_vectorized
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response.data?['synopse_auth_t_auth_user_profile'] as List;
      if (data.isNotEmpty) {
        if (data[0]['is_vectorized'] == 1) {
          prefs.setBool('isVector', true);
        }
      }
      return "success";
    } else {
      return "fail";
    }
  }

  Future<List<SynopseArticlesTV3ArticleGroupsL2>> getArticleDetails(
    int articleGroupId,
  ) async {
    const String query = '''
    query MyQuery(\$article_group_id: bigint!) {
      synopse_articles_t_v3_article_groups_l2(where: {article_group_id: {_eq: \$article_group_id}}) {
        articles_group
        t_v4_article_groups_l2_detail {
          ai_tags
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
          t_user_article_comments_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_likes_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_views_aggregate {
            aggregate {
              count
            }
          }
          t_user_article_bookmarks_aggregate {
            aggregate {
              count
            }
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v3_article_groups_l2'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV3ArticleGroupsL2.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4TagsHierarchyRootForYou>> getrootTags() async {
    const String query = '''
   query MyQuery {
      synopse_articles_t_v4_tags_hierarchy_root {
        tag_id
        tag
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v4_tags_hierarchy_root'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesTV4TagsHierarchyRootForYou.fromJson(
                  e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV1Outlet>> getArticlePublishersMain(
    String logoUrl,
  ) async {
    const String query = '''
    query MyQuery(\$logo_url: String!) {
      synopse_articles_t_v1_outlets(where: {logo_url: {_eq: \$logo_url}}) {
        logo_url
        outlet_display
        outlet_description
        outlet_id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "logo_url": logoUrl,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data = response.data?['synopse_articles_t_v1_outlets'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesTV1Outlet.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesVGet4Outlet>> get4Outlets() async {
    const String query = '''
    query MyQuery {
      synopse_articles_v_get4_outlets {
        logo_url
        outlet_display
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data = response.data?['synopse_articles_v_get4_outlets'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesVGet4Outlet.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV1Rss1ArticleF1>> getArticlePublisher(
    int limit,
    int offset,
    int outletId,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!\$offset: Int!\$_eq: bigint!) {
      synopse_articles_t_v1_rss1_articles(offset: \$offset, limit: \$limit, where: {outlet_id: {_eq: \$_eq}}) {
        article_id
        image_link
        post_link
        title
        t_article_meta {
          updated_at_formatted
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "_eq": outletId,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v1_rss1_articles'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV1Rss1ArticleF1.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4TagsHierarchyTree>> getTreeTags(
    int tagId,
  ) async {
    const String query = '''
    query MyQuery(\$tag_hierachy: Int!) {
      synopse_articles_t_v4_tags_hierarchy_tree(where: {tag_hierachy: {_eq: \$tag_hierachy}}) {
        tag_id
        tag
        tag_hierachy
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "tag_hierachy": tagId,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v4_tags_hierarchy_tree'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV4TagsHierarchyTree.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeTUserTag>> getUserIntrestTags() async {
    const String query = '''
   query MyQuery {
      synopse_realtime_t_user_tags {
        tag_id
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data = response.data?['synopse_realtime_t_user_tags'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseRealtimeTUserTag.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeVUserMetadatum>> getUserDetails(
    String account,
  ) async {
    const String query = '''
    query MyQuery(\$account: uuid = "") {
      synopse_realtime_v_user_metadata(where: {account: {_eq: \$account}}) {
        account
        member_since
        user_reputation
        user_following
        user_followers
        user_like_count
        user_comment_count
        user_view_count
        user_to_level {
          user_level_link {
            level_name
          }
          user_to_link {
            bio
            name
            photourl
            username
          }
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {"account": account};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data = response.data?['synopse_realtime_v_user_metadata'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseRealtimeVUserMetadatum.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeVUserLevel>> getMyUserLevel(
    String account,
  ) async {
    const String query = '''
    query MyQuery(\$account: uuid!) {
    synopse_realtime_v_user_level(where: {account: {_eq: \$account}}) {
      account
      level_no
      required_points
      user_reputation
      user_level_link {
        level_name
        level_no
        user_reputation_to
      }
      user_to_link {
        username
      }
      user_metadata {
        member_since
      }
    }
  }
  ''';
    Map<String, dynamic> variables = {"account": account};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }

    //log('$response');
    if (response is Success) {
      final data = response.data?['synopse_realtime_v_user_level'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseRealtimeVUserLevel.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseAuthTAuthUserProfile>> getMyUserNav1() async {
    const String query = '''
   query MyQuery {
      synopse_auth_t_auth_user_profile {
        nav1
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;

    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('nav1 $response');
    if (response is Success) {
      final data = response.data?['synopse_auth_t_auth_user_profile'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseAuthTAuthUserProfile.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<int> getUserExtFollow(
    String account,
  ) async {
    const String query = '''
    query MyQuery(\$account: uuid = "") {
      synopse_realtime_t_user_following_aggregate(where: {following: {_eq: \$account}}) {
        aggregate {
          count
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {"account": account};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_t_user_following_aggregate'];
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data?['aggregate']?['count'] as int;
      return searchArticles;
    } else {
      return 0;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v1_rss1_articles'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseArticlesTV1Rss1Article.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeTUserLevel>> getUserLevels() async {
    const String query = '''
    query MyQuery {
      synopse_realtime_t_user_levels(order_by: {level_no: desc}) {
        level_no
        level_name
        level_info
        user_reputation_from
        user_reputation_to
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data = response.data?['synopse_realtime_t_user_levels'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseRealtimeTUserLevel.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeVUserArticleCommentUser>> getUserComments(
    int limit,
    int offset,
    String account,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$account: uuid!) {
      synopse_realtime_v_user_article_comments(limit: \$limit, offset: \$offset, where: {account: {_eq: \$account}}) {
        comment
        id
        updated_at_formatted
        comments_like_count
        comments_dislike_count
        comment_to_article_group {
          title
          article_group_id
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "account": account,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    //log('$response');
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_v_user_article_comments'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeVUserArticleCommentUser.fromJson(
              e as Map<String, dynamic>))
          .toList();

      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeVUserArticleComment>> getArticleSComments(
    int limit,
    int offset,
    int articleGroupId,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$article_group_id: bigint!) {
      synopse_realtime_v_user_article_comments(limit: \$limit, offset: \$offset, where: {article_group_id: {_eq: \$article_group_id}, is_reply: {_eq: 0}}) {
          comment
          id
          comments_like_count
          comments_reply_count
          updated_at_formatted
          comments_dislike_count
          is_edited
          photourl
          account
          article_group_id
          username
          name
          comment_to_user_comment {
            t_user_comment_likes_aggregate {
              aggregate {
                count
              }
            }
            t_user_comment_dislikes_aggregate {
              aggregate {
                count
              }
            }
            user_comment_reply_count {
              reply_comment
            }
            is_edited
          }
          comment_to_article_group {
            title
            logo_urls
          }
        }
      }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "article_group_id": articleGroupId,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_v_user_article_comments'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeVUserArticleComment.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeVUserArticleComment>> getArticleComment(
    int commentId,
  ) async {
    const String query = '''
      query MyQuery(\$_eq: bigint!) {
        synopse_realtime_v_user_article_comments(where: {id: {_eq: \$_eq}}) {
          comment
          id
          comments_like_count
          comments_reply_count
          updated_at_formatted
          comments_dislike_count
          is_edited
          photourl
          account
          article_group_id
          username
          name
          comment_to_user_comment {
            t_user_comment_likes_aggregate {
              aggregate {
                count
              }
            }
            t_user_comment_dislikes_aggregate {
              aggregate {
                count
              }
            }
            user_comment_reply_count {
              reply_comment
            }
            is_edited
          }
          comment_to_article_group {
            title
            logo_urls
          }
        }
      }
  ''';
    Map<String, dynamic> variables = {
      "_eq": commentId,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_v_user_article_comments'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeVUserArticleComment.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<int> getSearchID(
    String search,
  ) async {
    const String query = '''
    query MyQuery(\$account1: uuid!, \$input_text: String!) {
      synopse_realtime_get_embedding(args: {account1: \$account1, input_text: \$input_text}) {
        id
      }
    }
    ''';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String account = prefs.getString('account') ?? "";
    if (account == "") {
      return 0;
    }
    Map<String, dynamic> variables = {
      "account1": account,
      "input_text": search,
    };

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response.data?['synopse_realtime_get_embedding'];
      var id = 0;
      if (data != null) {
        id = data['id'];
      }
      return id;
    } else {
      return 0;
    }
  }

  Future<List<SynopseRealtimeTUserArticleBookmark>> getArticleSaved(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!) {
      synopse_realtime_t_user_article_bookmarks(limit: \$limit, offset: \$offset, order_by: {created_at: desc}) {
        article_group_id
        t_v4_article_groups_l2_detail {
          title
          image_urls
          logo_urls
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
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_t_user_article_bookmarks'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeTUserArticleBookmark.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeVUserArticleComment>> getArticleSCommentsReply(
    int limit,
    int offset,
    int commentid,
  ) async {
    const String query = '''
    query MyQuery(\$limit: Int!, \$offset: Int!, \$comment_id: bigint!) {
      synopse_realtime_v_user_article_comments(limit: \$limit, offset: \$offset, where: {comment_id: {_eq: \$comment_id}, is_reply: {_eq: 1}}) {
          comment
          id
          comments_like_count
          comments_reply_count
          updated_at_formatted
          comments_dislike_count
          is_edited
          photourl
          account
          article_group_id
          username
          name
          comment_to_user_comment {
            t_user_comment_likes_aggregate {
              aggregate {
                count
              }
            }
            t_user_comment_dislikes_aggregate {
              aggregate {
                count
              }
            }
            user_comment_reply_count {
              reply_comment
            }
            is_edited
          }
        }
      }
  ''';
    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
      "comment_id": commentid,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_realtime_v_user_article_comments'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseRealtimeVUserArticleComment.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseArticlesTV4TagsHierarchyRoot>> getTaghierarchy() async {
    const String query = '''
    query MyQuery {
      synopse_articles_t_v4_tags_hierarchy_root {
        tag
        tag_id
        tags_hierarchy {
          tag_id
          tag
          tag_hierachy
          user_to_tag_aggregate {
            aggregate {
              count
            }
          }
        }
        
      }
    }

  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data =
          response.data?['synopse_articles_t_v4_tags_hierarchy_root'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) => SynopseArticlesTV4TagsHierarchyRoot.fromJson(
              e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<List<SynopseRealtimeTUserTagUI>> getUserTagIntrests() async {
    const String query = '''
    query MyQuery {
      synopse_realtime_t_user_tags {
        t_v4_tags_hierarchy {
          tag
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    dynamic response;
    if (isLoggedIn) {
      response = await service.performQuery(query, variables: variables);
    }
    if (response is Success) {
      final data = response.data?['synopse_realtime_t_user_tags'] as List;
      //log("SUCCESS DATA:${response.data.toString()}");
      final searchArticles = data
          .map((dynamic e) =>
              SynopseRealtimeTUserTagUI.fromJson(e as Map<String, dynamic>))
          .toList();
      return searchArticles;
    } else {
      return [];
    }
  }

  Future<String> setCombinedTabs(
    List nav1,
  ) async {
    const String query = '''
   mutation MyMutation(\$nav1: jsonb!) {
      update_synopse_auth_t_auth_user_profile(where: {}, _set: {nav1: \$nav1}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"nav1": nav1};
    final response = await service.performMutation(query, variables: variables);
    //log("nav1 11 RESPONSE:$response");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupView(
    int articleGroupId,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!) {
      insert_synopse_realtime_t_user_article_views_one(object: {article_group_id: \$article_group_id}, on_conflict: {constraint: t_user_article_views_pkey}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupLike(
    int articleGroupId,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint = "") {
      insert_synopse_realtime_t_user_article_likes_one(object: {article_group_id: \$article_group_id}, on_conflict: {constraint: t_user_article_likes_pkey}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupBookmark(
    int articleGroupId,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint = "") {
      insert_synopse_realtime_t_user_article_bookmarks_one(object: {article_group_id: \$article_group_id}, on_conflict: {constraint: t_user_article_bookmarks_pkey}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupViewDelete(
    int articleGroupId,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint = "") {
      delete_synopse_realtime_t_user_article_views(where: {article_group_id: {_eq: \$article_group_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupLikeDelete(
    int articleGroupId,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint = "") {
      delete_synopse_realtime_t_user_article_likes(where: {article_group_id: {_eq: \$article_group_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupBookmarkDelete(
    int articleGroupId,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint = "") {
      delete_synopse_realtime_t_user_article_bookmarks(where: {article_group_id: {_eq: \$article_group_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"article_group_id": articleGroupId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupComment(
    int articleGroupId,
    String comment,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$comment: String!) {
      insert_synopse_realtime_t_user_article_comments_one(object: {article_group_id: \$article_group_id, comment: \$comment}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "comment": comment
    };
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleSearchText(
    String searchText,
  ) async {
    const String query = '''
    mutation MyMutation(\$text: String = "") {
      insert_synopse_realtime_t_temp_user_search_with_text_one(object: {text: \$text}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "text": searchText,
    };
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupCommentReply(
    int articleGroupId,
    int commentId,
    String comment,
  ) async {
    const String query = '''
    mutation MyMutation(\$article_group_id: bigint!, \$comment: String!, \$comment_id: bigint!) {
      insert_synopse_realtime_t_user_article_comments_one(object: {article_group_id: \$article_group_id, comment: \$comment, is_reply: 1, comment_id: \$comment_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "article_group_id": articleGroupId,
      "comment": comment,
      "comment_id": commentId
    };
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setArticleGroupCommentEdit(
    int commentid,
    String comment,
  ) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint!, \$comment: String!) {
      update_synopse_realtime_t_user_article_comments(where: {id: {_eq: \$comment_id}}, _set: {is_edited: 1, comment: \$comment}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "comment_id": commentid,
      "comment": comment
    };
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserCommentLike(
    int commentId,
  ) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint = "") {
      insert_synopse_realtime_t_user_comment_likes_one(object: {comment_id: \$comment_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"comment_id": commentId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserCommentDislike(
    int commentId,
  ) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint = "") {
      insert_synopse_realtime_t_user_comment_dislikes_one(object: {comment_id: \$comment_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"comment_id": commentId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserCommentLikeDelete(
    int commentId,
  ) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint = "") {
      delete_synopse_realtime_t_user_comment_likes(where: {comment_id: {_eq: \$comment_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"comment_id": commentId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserCommentDislikeDelete(
    int commentId,
  ) async {
    const String query = '''
    mutation MyMutation(\$comment_id: bigint = "") {
      delete_synopse_realtime_t_user_comment_dislikes(where: {comment_id: {_eq: \$comment_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"comment_id": commentId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserTag(
    int tagId,
  ) async {
    const String query = '''
    mutation MyMutation(\$tag_id: Int = "") {
      insert_synopse_realtime_t_user_tags_one(object: {tag_id: \$tag_id}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"tag_id": tagId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> deleteUserTag(
    int tagId,
  ) async {
    const String query = '''
    mutation MyMutation(\$tag_id: Int = "") {
      delete_synopse_realtime_t_user_tags(where: {tag_id: {_eq: \$tag_id}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"tag_id": tagId};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setProfileBio(
    String bio,
  ) async {
    const String query = '''
    mutation MyMutation(\$bio: String = "") {
      update_synopse_auth_t_auth_user_profile(where: {}, _set: {bio: \$bio}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"bio": bio};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setProfileName(
    String name,
  ) async {
    const String query = '''
    mutation MyMutation(\$name: String = "") {
      update_synopse_auth_t_auth_user_profile(where: {}, _set: {name: \$name}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"name": name};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setProfileUsername(
    String username,
  ) async {
    const String query = '''
    mutation MyMutation(\$username: String = "") {
      update_synopse_auth_t_auth_user_profile(where: {}, _set: {username: \$username}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"username": username};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setProfilePhoto(
    int photo,
  ) async {
    const String query = '''
    mutation MyMutation(\$user_photo: Int!) {
      update_synopse_auth_t_auth_user_profile(where: {}, _set: {user_photo: \$user_photo}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"user_photo": photo};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserFollow(
    String account,
  ) async {
    const String query = '''
    mutation MyMutation(\$following: uuid = "") {
      insert_synopse_realtime_t_user_following_one(object: {following: \$following}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {"following": account};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserFollowDelete(
    String account,
  ) async {
    const String query = '''
    mutation MyMutation(\$following: uuid!) {
      delete_synopse_realtime_t_user_following(where: {following: {_eq: \$following}}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"following": account};
    final response = await service.performMutation(query, variables: variables);
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> updateUserNoNotification(
    int device,
    String deviceId,
    String deviceSeriel,
    String loginDate,
    String timezone,
  ) async {
    const String query = '''
    mutation MyMutation(\$device: Int!, \$deviceId: String!, \$device_seriel: String!, \$login_date: date!, \$timezone: String!) {
      insert_synopse_realtime_t_user_no_notification_one(object: {device: \$device, deviceId: \$deviceId, device_seriel: \$device_seriel, login_date: \$login_date, timezone: \$timezone}, on_conflict: {constraint: t_user_no_notification_account_device_deviceId_device_seriel_ke, update_columns: login_date}) {
        id
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "device": device,
      "deviceId": deviceId,
      "device_seriel": deviceSeriel,
      "login_date": loginDate,
      "timezone": timezone
    };

    final response = await service.performMutation(query, variables: variables);
    //log("UPDATE USER NO NOTIFICATION RESPONSE:$response");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> insertUserNotification(
    String fcmtoken,
    int device,
    String deviceId,
    String deviceSeriel,
    String loginDate,
    String timezone,
  ) async {
    const String query = '''
    mutation MyMutation(\$fcmtoken: String = "", \$device: Int = 10, \$deviceId: String = "", \$device_seriel: String = "", \$login_date: date = "", \$timezone: String = "") {
      insert_synopse_realtime_t_user_notification_fcm_one(object: {fcmtoken: \$fcmtoken, device: \$device, deviceId: \$deviceId, device_seriel: \$device_seriel, login_date: \$login_date, timezone: \$timezone}, on_conflict: {constraint: t_user_notification_fcm_fcmtoken_key, update_columns: login_date}) {
        id
      }
    }

  ''';
    Map<String, dynamic> variables = {
      "fcmtoken": fcmtoken,
      "device": device,
      "deviceId": deviceId,
      "device_seriel": deviceSeriel,
      "login_date": loginDate,
      "timezone": timezone
    };

    final response = await service.performMutation(query, variables: variables);
    //log("UPDATE USER NO NOTIFICATION RESPONSE:$response");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> insertFeedback(
    String type,
    String subject,
    String body,
  ) async {
    const String query = '''
    mutation MyMutation(\$type: String = "", \$subject: String = "", \$body: String = "") {
      insert_synopse_realtime_t_user_feedback(objects: {type: \$type, subject: \$subject, body: \$body}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "type": type,
      "subject": subject,
      "body": body,
    };

    final response = await service.performMutation(query, variables: variables);
    //log("UPDATE USER NO NOTIFICATION RESPONSE:$response");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> updateNotification(
    String fcmTokenOLD,
    String fcmtoken,
    int device,
    String deviceId,
    String deviceSeriel,
    String loginDate,
    String timezone,
  ) async {
    const String query = '''
    mutation MyMutation(\$fcmTokenOLD: String = "", \$device: Int = 10, \$deviceId: String = "", \$device_seriel: String = "", \$fcmtoken: String = "", \$id: bigint = "", \$login_date: date = "", \$timezone: String = "") {
      update_synopse_realtime_t_user_notification_fcm(where: {fcmtoken: {_eq: \$fcmTokenOLD}}, _set: {device: \$device, deviceId: \$deviceId, device_seriel: \$device_seriel, fcmtoken: \$fcmtoken, id: \$id, login_date: \$login_date, timezone: \$timezone}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {
      "fcmTokenOLD": fcmTokenOLD,
      "fcmtoken": fcmtoken,
      "device": device,
      "deviceId": deviceId,
      "device_seriel": deviceSeriel,
      "login_date": loginDate,
      "timezone": timezone
    };

    final response = await service.performMutation(query, variables: variables);
    //log("UPDATE USER NO NOTIFICATION RESPONSE:$response");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }
}
