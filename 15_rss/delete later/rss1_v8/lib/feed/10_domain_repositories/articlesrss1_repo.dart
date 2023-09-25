import 'dart:async';

import 'package:rss1_v8/core/utils/api_response.dart';
import 'package:rss1_v8/feed/04_domain_entities/dm_articlerss1.dart';

abstract class ArticalsRss1Repository {
  Future<ApiResponse<Rss1ArticleList>> getArticlesRss1List(
      int limit, int offset);
}
