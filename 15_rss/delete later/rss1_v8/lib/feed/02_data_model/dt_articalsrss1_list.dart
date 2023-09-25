import 'package:rss1_v8/feed/02_data_model/dt_articlesrss1.dart';

class DTArticalsRss1List {
  DTArticalsRss1List(this.articalsrss1List);

  DTArticalsRss1List.fromJson(Map<String, dynamic> map)
      : articalsrss1List = List<DTRss1Article>.from(
          (map['rss1_articals'].cast<Map<String, dynamic>>())
              .toList()
              .map(DTRss1Article.fromJson),
        );
  final List<DTRss1Article> articalsrss1List;

  @override
  String toString() {
    return '$articalsrss1List';
  }
}
