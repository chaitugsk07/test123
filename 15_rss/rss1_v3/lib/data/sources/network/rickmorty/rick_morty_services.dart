import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:rss1_v3/data/models/characters/dt_character_info.dart';
import 'package:rss1_v3/data/models/characters/dt_character_list.dart';
import 'package:rss1_v3/data/models/locations/dt_location_list.dart';
import 'package:rss1_v3/domain/entities/api_response.dart';
import '../graphql/graphql_service.dart';

@injectable
class RickMortyServices {
  RickMortyServices(this.service);

  final GraphQLService service;

  Future<ApiResponse<DTCharactersList>> getCharactersList(
    int page,
    String nameFilter,
  ) async {
    final query = '''
      query {
        characters(page: $page, filter: { name: "$nameFilter" }) {
          info {
            count
          }
          results {
            id
            name
            status
            image
            species
          }
        }
      }
    ''';

    final response = await service.performQuery(query, variables: {});
    log('$response');

    if (response is Success) {
      return Success(
        data: DTCharactersList.fromJson(response.data as Map<String, dynamic>),
      );
    } else {
      return Failure(error: (response as Failure).error);
    }
  }

  Future<ApiResponse<DTCharacterInfo>> getCharacterInfo(int id) async {
    final query = '''{
      character(id: $id) {
        id
        name
        image
        status
        species
        gender
        origin {
          id
          name
        }
        location {
          id
          name
        }
      }
    }''';

    final response = await service.performQuery(query, variables: {});
    log('$response');

    if (response is Success) {
      DTCharacterInfo? info;
      try {
        info = DTCharacterInfo.fromJson(
          response.data['character'] as Map<String, dynamic>,
        );
      } on Exception catch (e) {
        log('error', error: e);
        return Failure(error: Exception(e));
      }
      return Success(data: info);
    } else {
      return Failure(error: (response as Failure).error);
    }
  }

  Future<ApiResponse<DTLocationsList>> getLocationsList() async {
    const query = '''
        query {
          locations {
            info {
              count
            }
            results {
              id
              name
              type
              dimension
              created
            }
        }
      }
    ''';

    final response = await service.performQuery(query, variables: {});
    log('$response');

    if (response is Success) {
      return Success(
        data: DTLocationsList.fromJson(response.data as Map<String, dynamic>),
      );
    } else {
      return Failure(error: (response as Failure).error);
    }
  }
}
