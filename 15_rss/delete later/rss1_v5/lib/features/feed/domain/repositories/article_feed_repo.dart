import 'dart:async';

import '../../../../core/utils/api_response.dart';
import '../entities/dm_article_feed.dart';

abstract class ArticleFeedRepository {
  Future<ApiResponse<ArticleFeedList>> getArticleFeedList(
      int limit, int offset);
}
