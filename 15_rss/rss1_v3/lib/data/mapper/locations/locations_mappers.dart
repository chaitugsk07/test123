import 'package:injectable/injectable.dart';
import 'package:rss1_v3/data/mapper/entity_mapper.dart';
import 'package:rss1_v3/data/models/locations/dt_location.dart';
import 'package:rss1_v3/data/models/locations/dt_location_list.dart';
import 'package:rss1_v3/domain/entities/locations/dm_location.dart';

@injectable
class LocationListMapper extends EntityMapper<LocationList, DTLocationsList> {
  LocationListMapper(this.locationMapper);

  LocationMapper locationMapper;

  @override
  DTLocationsList mapToData(LocationList model) {
    return DTLocationsList(
      model.locationList.map((e) => locationMapper.mapToData(e)).toList(),
    );
  }

  @override
  LocationList mapToDomain(DTLocationsList entity) {
    return LocationList(
      entity.locationsList.map((e) => locationMapper.mapToDomain(e)).toList(),
    );
  }
}

@injectable
class LocationMapper extends EntityMapper<Location, DTLocation> {
  @override
  DTLocation mapToData(Location model) {
    return DTLocation(
      model.id,
      model.name,
      model.type,
      model.dimension,
      model.created,
    );
  }

  @override
  Location mapToDomain(DTLocation entity) {
    return Location(
      entity.id,
      entity.name,
      entity.type,
      entity.dimension,
      entity.created,
    );
  }
}
