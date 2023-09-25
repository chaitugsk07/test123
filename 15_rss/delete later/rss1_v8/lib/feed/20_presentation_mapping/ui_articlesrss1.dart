import 'package:rss1_v8/core/utils/ui_model.dart';

class UiArticleRss1 extends UIModel {
  String? postLink,
      imageLink,
      title,
      summary,
      author,
      postPublished,
      outlet,
      rss1LinkName;
  UiArticleRss1(
      {this.postLink,
      this.imageLink,
      this.title,
      this.summary,
      this.author,
      this.postPublished,
      this.outlet,
      this.rss1LinkName});
}

class UiArticleRss1List extends UIModel {
  List<UiArticleRss1> uiArticleRss1;

  UiArticleRss1List(this.uiArticleRss1);
}
