import 'package:injectable/injectable.dart';
import 'package:rss1_v1/core/utils/entity_mapper.dart';
import 'package:rss1_v1/features/02_article_feed/data/01_model/dt_artical_feed.dart';
import 'package:rss1_v1/features/02_article_feed/data/01_model/dt_artical_feed_list.dart';
import 'package:rss1_v1/features/02_article_feed/domain/02_entity/artical_feed.dart';

@injectable
class ArticleFeedMapper extends EntityMapper<Rss1Artical, DTRss1Artical> {
  @override
  DTRss1Artical mapToData(Rss1Artical model) {
    return DTRss1Artical(
        model.postLink,
        model.imageLink,
        model.title,
        model.summary,
        model.author,
        model.postPublished,
        model.isDefaultImage,
        DTRss1LinkByRss1Link(
          model.rss1LinkByRss1Link?.outlet,
          model.rss1LinkByRss1Link?.rss1LinkName,
          DTRss1Outlet(
            model.rss1LinkByRss1Link?.rss1Outlet?.logoUrl,
            model.rss1LinkByRss1Link?.rss1Outlet?.outletDisplay,
          ),
        ));
  }

  @override
  Rss1Artical mapToDomain(DTRss1Artical entity) {
    return Rss1Artical(
      entity.postLink,
      entity.imageLink,
      entity.title,
      entity.summary,
      entity.author,
      entity.postPublished,
      entity.isDefaultImage,
      Rss1LinkByRss1Link(
        entity.rss1LinkByRss1Link?.outlet,
        entity.rss1LinkByRss1Link?.rss1LinkName,
        Rss1Outlet(
          entity.rss1LinkByRss1Link?.rss1Outlet?.logoUrl,
          entity.rss1LinkByRss1Link?.rss1Outlet?.outletDisplay,
        ),
      ),
    );
  }
}

@injectable
class ArticleFeedListMapper
    extends EntityMapper<Rss1ArticalList, DTRss1ArticalList> {
  @override
  DTRss1ArticalList mapToData(Rss1ArticalList model) {
    return DTRss1ArticalList(
      model.articalRss1List
          .map((e) => ArticleFeedMapper().mapToData(e))
          .toList(),
    );
  }

  @override
  Rss1ArticalList mapToDomain(DTRss1ArticalList entity) {
    return Rss1ArticalList(
      entity.rss1ArticalsList
          .map((e) => ArticleFeedMapper().mapToDomain(e))
          .toList(),
    );
  }
}
