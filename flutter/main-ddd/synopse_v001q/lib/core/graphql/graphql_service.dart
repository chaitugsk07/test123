import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_exception.dart';
import '../utils/api_response.dart';

@singleton
class GraphQLService {
  GraphQLService() {
    init();
  }
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final auth = prefs.getString('auth') ?? '';
        final authHeader = 'Bearer $auth';
        return authHeader;
      },
    );
    final HttpLink httpLink = HttpLink(
      'https://enabling-elk-81.hasura.app/v1/graphql',
    );

    final Link link = authLink.concat(httpLink);
    _graphQLClientLoggedIn = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
    final link1 = HttpLink('https://enabling-elk-81.hasura.app/v1/graphql');
    _graphQLClient = GraphQLClient(
      link: link1,
      cache: GraphQLCache(),
    );
  }

  late final GraphQLClient _graphQLClient;
  late final GraphQLClient _graphQLClientLoggedIn;

  Future<ApiResponse<dynamic>> performQuery(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    try {
      final options = QueryOptions(
        document: gql(query),
        variables: variables,
      );
      dynamic result;
      try {
        result = await _graphQLClient.query(options);
      } catch (_) {
        await init();
        result = await _graphQLClient.query(options);
      }
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

  Future<ApiResponse<dynamic>> performQueryL(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    try {
      final options = QueryOptions(
        document: gql(query),
        variables: variables,
      );
      dynamic result;
      try {
        result = await _graphQLClientLoggedIn.query(options);
      } catch (_) {
        await init();
        result = await _graphQLClientLoggedIn.query(options);
      }
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

    final result = await _graphQLClientLoggedIn.mutate(options);

    log(result.toString());

    return result;
  }
}
