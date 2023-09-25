import 'dart:async';

import 'package:rss1_v1/core/graphql/api_response.dart';
import 'package:rss1_v1/features/02_article_feed/domain/02_entity/artical_feed.dart';

abstract class ArticalsRss1Repository {
  Future<ApiResponse<Rss1ArticalList>> getArticlesRss1List(
      int limit, int offset);
}
