import 'dt_artical_feed.dart';

class DTRss1ArticalList {
  final List<DTRss1Artical> rss1ArticalsList;

  DTRss1ArticalList(this.rss1ArticalsList);

  DTRss1ArticalList.fromJson(Map<String, dynamic> map)
      : rss1ArticalsList = List<DTRss1Artical>.from(
          (map['rss1_articals'].cast<Map<String, dynamic>>())
              .toList()
              .map(DTRss1Artical.fromJson),
        );
  @override
  String toString() {
    return '$rss1ArticalsList';
  }
}
