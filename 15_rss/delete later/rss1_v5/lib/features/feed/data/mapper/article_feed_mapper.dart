import 'package:injectable/injectable.dart';

import '../../../../core/utils/entity_mapper.dart';
import '../../domain/entities/dm_article_feed.dart';
import '../models/dt_artical_feed.dart';
import '../models/dt_artical_feed_list.dart';

class ArticleListMapper implements EntityMapper<ArticleFeedList, DTRss1ArticalsList> {
  @override
  DTRss1ArticalsList mapToData(ArticleFeedList model) {
    // TODO: implement mapToData
    throw UnimplementedError();
  }

  @override
  ArticleFeedList mapToDomain(DTRss1ArticalsList entity) {
    // TODO: implement mapToDomain
    throw UnimplementedError();
  }

}

@injectable
class ArticleMapper extends EntityMapper<Article, DTRss1Artical> {
  @override
  DTRss1Artical mapToData(Article model) {
    return DTRss1Artical(
      
    );
  }

  @override
  Character mapToDomain(DTCharacter entity) {
    return Character(
      entity.id,
      entity.name,
      entity.image,
      entity.status,
      entity.species,
    );
  }
}
