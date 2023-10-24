import 'dart:developer';

import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';
import 'package:synopse_v001/features/03_user_profile/01_models_repo/mod_user_counts.dart';
import 'package:synopse_v001/features/03_user_profile/01_models_repo/mod_user_profile.dart';

class UserProfileService {
  UserProfileService(this.service);

  final GraphQLService service;

  Future<String> setUserProfileUserName(String userName) async {
    const String query = '''
    mutation MyMutation(\$username: String!) {
      update_auth_auth1_users(where: {}, _set: { username: \$username}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"username": userName};
    final response = await service.performMutation(query, variables: variables);
    print("insert User SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserProfileBio(String bio) async {
    const String query = '''
    mutation MyMutation(\$bio: String!) {
      update_auth_auth1_users(where: {}, _set: {bio: \$bio}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"bio": bio};
    final response = await service.performMutation(query, variables: variables);
    log("insert Bio SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<String> setUserProfilePhoto(int userPhoto) async {
    const String query = '''
    mutation MyMutation(\$user_photo: Int!) {
      update_auth_auth1_users(where: {}, _set: {user_photo: \$user_photo}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"user_photo": userPhoto};
    final response = await service.performMutation(query, variables: variables);
    log("insert Photo SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }

  Future<List<AuthAuth1User>> getUserProfile() async {
    const String query = '''
    query MyQuery {
      auth_auth1_users {
        account
        bio
        user_photo
        username
      }
    }
  ''';
    Map<String, dynamic> variables = {};
    final response = await service.performQueryL(query, variables: variables);
    log('$response');
    if (response is Success) {
      final data = response.data?['auth_auth1_users'] as List;
      log("SUCCESS DATA:${response.data.toString()}");
      final newArticles = data
          .map((dynamic e) => AuthAuth1User.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }

  Future<List<UserCounts>> getUserCountProfile(String userid) async {
    const String query = '''
    query MyQuery(\$user_uuid: uuid!) {
      articles_v_user_views_aggregate(where: {user_id: {_eq: \$user_uuid}}) {
        aggregate {
          count
        }
      }
      articles_v_user_likes_aggregate(where: {user_id: {_eq: \$user_uuid}}) {
        aggregate {
          count
        }
      }
      articles_v_user_comments_aggregate(where: {user_id: {_eq: \$user_uuid}}) {
        aggregate {
          count
        }
      }
      articles_v_user_followers_aggregate (where: {user_id_following: {_eq: \$user_uuid}}) {
        aggregate {
          count
        }
      }
      articles_v_user_following_aggregate (where: {user_id_follows: {_eq: \$user_uuid}}) {
        aggregate {
          count
        }
      }
    }
  ''';
    Map<String, dynamic> variables = {"user_uuid": userid};
    final response = await service.performQueryL(query, variables: variables);
    log('$response');
    if (response is Success) {
      log("SUCCESS DATA:${response.data.toString()}");
      int viewsCount = (response.data?['articles_v_user_views_aggregate']
          ['aggregate']['count']);
      int likesCount = (response.data?['articles_v_user_likes_aggregate']
          ['aggregate']['count']);
      int commentsCount = (response.data?['articles_v_user_comments_aggregate']
          ['aggregate']['count']);
      int followersCount = (response
          .data?['articles_v_user_followers_aggregate']['aggregate']['count']);
      int followingCount = (response
          .data?['articles_v_user_following_aggregate']['aggregate']['count']);
      List<Map<String, int>> userProfile = [
        {
          'views': viewsCount,
          'likes': likesCount,
          'comments': commentsCount,
          'followers': followersCount,
          'following': followingCount,
        }
      ];
      final newArticles = userProfile
          .map((dynamic e) => UserCounts.fromJson(e as Map<String, dynamic>))
          .toList();
      return newArticles;
    } else {
      return [];
    }
  }
}
