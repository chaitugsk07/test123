import 'package:injectable/injectable.dart';
import 'package:rss1_v8/core/utils/ui_model_mapper.dart';
import 'package:rss1_v8/feed/04_domain_entities/dm_articlerss1.dart';
import 'package:rss1_v8/feed/20_presentation_mapping/ui_articlesrss1.dart';

@injectable
class UiArticlesRss1Mapper
    extends UiModelMapper<Rss1ArticleList, UiArticleRss1List> {
  @override
  Rss1ArticleList mapToDomain(UiArticleRss1List modelItem) {
    return Rss1ArticleList(modelItem.uiArticleRss1
        .map((e) => Rss1Article(
            e.postLink,
            e.imageLink,
            e.title,
            e.summary,
            e.author,
            e.postPublished as DateTime?,
            Rss1LinkByRss1Link(e.outlet, e.rss1LinkName)))
        .cast<Rss1Article>()
        .toList());
  }

  @override
  UiArticleRss1List mapToPresentation(Rss1ArticleList model) {
    return UiArticleRss1List(model.rss1ArticleList
        .map((e) => UiArticleRss1(
              postLink: e.postLink,
              imageLink: e.imageLink,
              title: e.title,
              summary: e.summary,
              postPublished: e.postPublished.toString(),
              author: e.author,
              outlet: e.rss1LinkByRss1Link?.outlet,
              rss1LinkName: e.rss1LinkByRss1Link?.rss1LinkName,
            ))
        .toList());
  }
}
