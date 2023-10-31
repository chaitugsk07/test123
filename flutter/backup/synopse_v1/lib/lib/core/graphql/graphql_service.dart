import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_exception.dart';
import '../utils/api_response.dart';

@singleton
class GraphQLService {
  late final GraphQLClient _graphQLClient;
  GraphQLService() {
    init();
  }
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final AuthLink authLink = AuthLink(
        getToken: () async {
          final auth = prefs.getString('auth');
          final authHeader = 'Bearer $auth';
          return authHeader;
        },
      );
      final link = authLink.concat(
        HttpLink('https://enabling-elk-81.hasura.app/v1/graphql'),
      );
      _graphQLClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      );
    } else {
      final link = HttpLink('https://enabling-elk-81.hasura.app/v1/graphql');
      _graphQLClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      );
    }
  }

  Future<ApiResponse<dynamic>> performQuery(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    try {
      final options = QueryOptions(
        document: gql(query),
        variables: variables,
      );

      final result = await _graphQLClient.query(options);

      if (result.hasException) {
        final errorCode =
            result.context.entry<HttpLinkResponseContext>()?.statusCode ?? 0;
        return Failure(
          error: APIException(result.exception.toString(), errorCode, ''),
        );
      } else {
        return Success(data: result.data);
      }
    } on Exception catch (_, e) {
      return Failure(error: APIException(e.toString(), 0, ''));
    }
  }

  Future<QueryResult> performMutation(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = MutationOptions(document: gql(query), variables: variables);

    final result = await _graphQLClient.mutate(options);

    log(result.toString());

    return result;
  }
}
