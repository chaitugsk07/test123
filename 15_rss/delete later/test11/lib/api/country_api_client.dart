import 'package:graphql/client.dart';
import 'package:graphql_example/api/models/models.dart';
import 'package:graphql_example/api/quries/queries.dart' as queries;

class GetCountriesRequestFailure implements Exception {}

class CountriesApiClient {
  const CountriesApiClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory CountriesApiClient.create() {
    final httpLink = HttpLink('https://countries.trevorblades.com');
    final link = Link.from([httpLink]);
    return CountriesApiClient(
      graphQLClient: GraphQLClient(cache: GraphQLCache(), link: link),
    );
  }

  final GraphQLClient _graphQLClient;

  Future<List<CountryModel>> getCountries() async {
    final result = await _graphQLClient.query(
      QueryOptions(document: gql(queries.getCountries)),
    );
    if (result.hasException) throw GetCountriesRequestFailure();
    final data = result.data?['countries'] as List;
    print("SUCCESS DATA:${result.data.toString()}");
    return data
        .map((dynamic e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CountryModel> getCountryById(String code) async {
    final result = await _graphQLClient.mutate(
      MutationOptions(
        variables: {'code': code},
        document: gql(r'''
         query GetCountryByCode($code:ID!){
         country(code: $code) {
              name
              native
              capital
              emoji
              currency
            }
         }
        '''),
      ),
    );
    if (result.hasException) throw GetCountriesRequestFailure();
    final data = result.data?['country'] as Map<String, dynamic>;
    return CountryModel.fromJson(data);
  }
}
