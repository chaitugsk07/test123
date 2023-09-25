import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:rss1_v8/core/graphql/graphql_service.dart';
import 'package:rss1_v8/core/utils/api_response.dart';
import 'package:rss1_v8/feed/02_data_model/dt_articalsrss1_list.dart';

@injectable
class RssFeedServices {
  RssFeedServices(this.service);

  final GraphQLService service;

  Future<ApiResponse<DTArticalsRss1List>> getArticleRssFeed(
    int limit,
    int offset,
  ) async {
    final query = '''
      query MyQuery @cached {
        rss1_articals(limit: $limit, offset: $offset, order_by: {post_published: desc}) {
          post_link
          image_link
          title
          summary
          author
          post_published
          rss1LinkByRss1Link {
            outlet
            rss1_link_name
          }
        }
      }
    ''';

    final response = await service.performQuery(query, variables: {});
    log('$response');

    if (response is Success) {
      return Success(
        data:
            DTArticalsRss1List.fromJson(response.data as Map<String, dynamic>),
      );
    } else {
      return Failure(error: (response as Failure).error);
    }
  }
}
