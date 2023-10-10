import 'package:synopse_v001/core/graphql/graphql_service.dart';
import 'package:synopse_v001/core/utils/api_response.dart';

class UserProfileService {
  UserProfileService(this.service);

  final GraphQLService service;

  Future<String> setUserProfile(String userName, String bio) async {
    const String query = '''
    mutation MyMutation(\$bio: String!, \$username: String!) {
      update_auth_auth1_users(where: {}, _set: {bio: \$bio, username: \$username}) {
        affected_rows
      }
    }
  ''';
    Map<String, dynamic> variables = {"bio": bio, "username": userName};
    final response = await service.performMutation(query, variables: variables);
    print("insert SUCCESS DATA:${response.data.toString()}");
    if (response is Success) {
      return "success";
    }
    return "fail";
  }
}
