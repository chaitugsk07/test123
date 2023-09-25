import 'dt_artical_feed.dart';

class DTRss1ArticalsList {
  DTRss1ArticalsList(this.rss1ArticalsList);

  DTRss1ArticalsList.fromJson(Map<String, dynamic> map)
      : rss1ArticalsList = List<DTRss1Artical>.from(
          (map['data']['rss1_articals'].cast<Map<String, dynamic>>())
              .toList()
              .map(DTRss1Artical.fromJson),
        );

  final List<DTRss1Artical> rss1ArticalsList;

  @override
  String toString() {
    return '$rss1ArticalsList';
  }
}
