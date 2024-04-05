import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synopse/core/utils/api_exception.dart';
import 'package:synopse/core/utils/api_response.dart';

class GraphQLService {
  late final GraphQLClient _graphQLClient;
  late bool isValid = false;
  GraphQLService() {
    initialize().then((_) {
      isValid = true;
    });
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final link1 = HttpLink(prefs.getString('graphql') ?? '');
    _graphQLClient = GraphQLClient(
      link: link1,
      cache: GraphQLCache(),
    );
  }

  Future<void> waitForValidity() async {
    while (!isValid) {
      await Future.delayed(const Duration(
          milliseconds:
              100)); // Wait for  100 milliseconds before checking again
    }
  }

  Future<ApiResponse<dynamic>> performQuery(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    await waitForValidity();
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
    await waitForValidity();
    final options = MutationOptions(document: gql(query), variables: variables);

    final result = await _graphQLClient.mutate(options);

    // log(result.toString());

    return result;
  }
}
