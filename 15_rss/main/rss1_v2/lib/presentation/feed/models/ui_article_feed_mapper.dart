import 'package:rss1_v2/core/utils/ui_model_mapper.dart';
import 'package:rss1_v2/domain/02_entities/feed/artical_feed.dart';
import 'package:rss1_v2/presentation/feed/models/ui_article_feed.dart';

class UiAticleFeedMapper extends UiModelMapper<Rss1Artical, UiRss1Artical> {
  @override
  Rss1Artical mapToDomain(UiRss1Artical modelItem) {
    return Rss1Artical(
        modelItem.postLink,
        modelItem.imageLink,
        modelItem.title,
        modelItem.summary,
        modelItem.author,
        modelItem.postPublished,
        modelItem.isDefaultImage,
        Rss1LinkByRss1Link(
            modelItem.rss1LinkByRss1Link.outlet,
            modelItem.rss1LinkByRss1Link.rss1LinkName,
            Rss1Outlet(modelItem.rss1LinkByRss1Link.rss1Outlet.logoUrl,
                modelItem.rss1LinkByRss1Link.rss1Outlet.outletDisplay)));
  }

  @override
  UiRss1Artical mapToPresentation(Rss1Artical model) {
    return UiRss1Artical(
        model.postLink,
        model.imageLink,
        model.title,
        model.summary,
        model.author,
        model.postPublished,
        model.isDefaultImage,
        UiRss1LinkByRss1Link(
            model.rss1LinkByRss1Link.outlet,
            model.rss1LinkByRss1Link.rss1LinkName,
            UiRss1Outlet(model.rss1LinkByRss1Link.rss1Outlet.logoUrl,
                model.rss1LinkByRss1Link.rss1Outlet.outletDisplay)));
  }
}

class UiAticleFeedListMapper
    extends UiModelMapper<Rss1ArticalList, UiRss1ArticalList> {
  @override
  Rss1ArticalList mapToDomain(UiRss1ArticalList modelItem) {
    return Rss1ArticalList(modelItem.rss1ArticalList
        .map((e) => UiAticleFeedMapper().mapToDomain(e))
        .toList());
  }

  @override
  UiRss1ArticalList mapToPresentation(Rss1ArticalList model) {
    return UiRss1ArticalList(model.articalRss1List
        .map((e) => UiAticleFeedMapper().mapToPresentation(e))
        .toList());
  }
}
