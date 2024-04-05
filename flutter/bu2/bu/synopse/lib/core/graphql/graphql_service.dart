import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/utils/api_exception.dart';
import 'package:synopse/core/utils/api_response.dart';
import 'package:synopse/features/02_login_screens/bloc/set_token.dart';

class GraphQLService {
  GraphQLService() {
    initialize();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final AuthLink authLink = AuthLink(
      getToken: () async {
        logintokenvalidity();
        final auth = prefs.getString('loginToken') ?? '';
        return auth;
      },
    );
    final HttpLink httpLink = HttpLink(prefs.getString('graphql') ?? '');

    final Link link = authLink.concat(httpLink);
    _graphQLClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  late final GraphQLClient _graphQLClient;

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
