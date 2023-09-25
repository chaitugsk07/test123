import '../../../../core/utils/entity_mapper.dart';
import '../../domain/entities/dm_article_feed.dart';
import '../models/dt_artical_feed.dart';

class ArticleMapper implements EntityMapper<ArticleFeedList, DTRss1ArticalsList> {
  @override
  Article mapToDomain(DtArticalFeed data) {
    final List<Article> articles = data.data?.rss1Articals?.map((rss1Artical) {
          return Article(
            postLink: rss1Artical.postLink ?? '',
            imageLink: rss1Artical.imageLink ?? '',
            title: rss1Artical.title ?? '',
            summary: rss1Artical.summary ?? '',
            author: rss1Artical.author ?? '',
            postPublished: rss1Artical.postPublished ?? DateTime.now(),
            rss1Link: Rss1Link(
              outlet: rss1Artical.rss1LinkByRss1Link?.outlet ?? '',
              rss1LinkName: rss1Artical.rss1LinkByRss1Link?.rss1LinkName ?? '',
            ),
          );
        }).toList() ??
        [];

    return articles.first;
  }

  @override
  DtArticalFeed mapToData(Article model) {
    final rss1Articals = [
      Rss1Artical(
        postLink: model.postLink,
        imageLink: model.imageLink,
        title: model.title,
        summary: model.summary,
        author: model.author,
        postPublished: model.postPublished,
        rss1LinkByRss1Link: Rss1LinkByRss1Link(
          outlet: model.rss1Link.outlet,
          rss1LinkName: model.rss1Link.rss1LinkName,
        ),
      )
    ];

    return DtArticalFeed(
      data: Data(
        rss1Articals: rss1Articals,
      ),
    );
  }
}
