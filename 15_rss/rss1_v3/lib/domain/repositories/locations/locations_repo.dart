import 'dart:async';

import 'package:rss1_v3/domain/entities/api_response.dart';
import 'package:rss1_v3/domain/entities/locations/dm_location.dart';

abstract class LocationsRepository {
  Future<ApiResponse<LocationList>> getLocations();
}
