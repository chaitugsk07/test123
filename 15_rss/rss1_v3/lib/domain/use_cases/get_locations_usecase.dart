import 'dart:async';

import 'package:rss1_v3/core/clean_architecture/usecase.dart';
import 'package:rss1_v3/domain/entities/api_response.dart';
import 'package:rss1_v3/domain/entities/locations/dm_location.dart';
import 'package:rss1_v3/domain/repositories/locations/locations_repo.dart';

class GetLocationsUseCase extends UseCase<LocationListUseCaseResponse, void> {
  final LocationsRepository repo;

  GetLocationsUseCase(this.repo);

  @override
  Future<Stream<LocationListUseCaseResponse>> buildUseCaseStream(
      void params) async {
    final controller = StreamController<LocationListUseCaseResponse>();
    try {
      // Fetch from repository
      final locationList = await repo.getLocations();
      // Adding it triggers the .onNext() in the `Observer`
      controller.add(LocationListUseCaseResponse(locationList));
      logger.finest('GetLocationsUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetLocationsUseCase failure.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class LocationListUseCaseResponse {
  final ApiResponse<LocationList> locationList;

  LocationListUseCaseResponse(this.locationList);
}
