import 'dart:async';

import 'package:rss1_v2/core/utils/api_response.dart';
import 'package:rss1_v2/domain/02_entities/feed/artical_feed.dart';

abstract class ArticalsRss1Repository {
  Future<ApiResponse<Rss1ArticalList>> getArticlesRss1List(
      int limit, int offset);
}
