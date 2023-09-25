import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:rss1_v2/core/utils/api_response.dart';
import 'package:rss1_v2/data/01_models/feed/dt_artical_feed_list.dart';
import 'package:rss1_v2/data/04_sources/graphql/graphql_service.dart';

@injectable
class ArticleFeedServices {
  ArticleFeedServices(this.service);

  final GraphQLService service;

  Future<ApiResponse<DTRss1ArticalList>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    const String query = '''
    query MyQuery(\$offset: Int!, \$limit: Int!) @cached {
      rss1_articals(limit: \$limit, offset: \$offset, order_by: {post_published: desc}, where: {is_default_image: {_eq: 1}, is_in_detail: {_eq: 1}}) {
        post_link
        image_link
        title
        summary
        author
        post_published
        is_default_image
        rss1LinkByRss1Link {
          outlet
          rss1_link_name
          rss1_outlet {
            logo_url
            outlet_display
          }
        }
      }
    }
  ''';

    Map<String, dynamic> variables = {
      "offset": offset,
      "limit": limit,
    };
    final response = await service.performQuery(query, variables: variables);
    log('$response');

    if (response is Success) {
      return Success(
        data: DTRss1ArticalList.fromJson(response.data as Map<String, dynamic>),
      );
    } else {
      return Failure(error: (response as Failure).error);
    }
  }
}
