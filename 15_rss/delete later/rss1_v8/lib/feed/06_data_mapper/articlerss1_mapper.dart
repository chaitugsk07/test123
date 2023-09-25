import 'package:injectable/injectable.dart';
import 'package:rss1_v8/core/utils/entity_mapper.dart';
import 'package:rss1_v8/feed/02_data_model/dt_articalsrss1_list.dart';
import 'package:rss1_v8/feed/02_data_model/dt_articlesrss1.dart';
import 'package:rss1_v8/feed/04_domain_entities/dm_articlerss1.dart';

@injectable
class Rss1ArticleMapper extends EntityMapper<DTRss1Article, Rss1Article> {
  @override
  Rss1Article mapToData(DTRss1Article model) {
    return Rss1Article(
        model.postLink,
        model.imageLink,
        model.title,
        model.summary,
        model.author,
        model.postPublished as DateTime?,
        DTRss1LinkByRss1Link(model.rss1LinkByRss1Link?.outlet,
            model.rss1LinkByRss1Link?.rss1LinkName) as Rss1LinkByRss1Link?);
  }

  @override
  DTRss1Article mapToDomain(Rss1Article entity) {
    return DTRss1Article(
        entity.postLink,
        entity.imageLink,
        entity.title,
        entity.summary,
        entity.author,
        entity.postPublished.toString(),
        DTRss1LinkByRss1Link(entity.rss1LinkByRss1Link?.outlet,
            entity.rss1LinkByRss1Link?.rss1LinkName));
  }
}

@injectable
class Rss1ArticleListMapper
    extends EntityMapper<Rss1ArticleList, DTArticalsRss1List> {
  Rss1ArticleListMapper(this.rss1ArticleMapper);

  Rss1ArticleMapper rss1ArticleMapper;

  @override
  DTArticalsRss1List mapToData(Rss1ArticleList model) {
    return DTArticalsRss1List(model.rss1ArticleList
        .map((e) => rss1ArticleMapper.mapToData(e as DTRss1Article))
        .cast<DTRss1Article>()
        .toList());
  }

  @override
  Rss1ArticleList mapToDomain(DTArticalsRss1List entity) {
    return Rss1ArticleList(entity.articalsrss1List
        .map((e) => rss1ArticleMapper.mapToDomain(e as Rss1Article))
        .cast<Rss1Article>()
        .toList());
  }
}
