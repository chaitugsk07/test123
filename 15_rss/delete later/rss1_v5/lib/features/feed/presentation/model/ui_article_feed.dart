import '../../../../core/utils/ui_model.dart';

class UiArticle extends UIModel {
  String postLink, imageLink, title, summary, author, outlet, rss1LinkName;
  DateTime postPublished;

  UiArticle({
    required this.postLink,
    required this.imageLink,
    required this.title,
    required this.summary,
    required this.author,
    required this.postPublished,
    required this.outlet,
    required this.rss1LinkName,
  });
}

class UiArticleList extends UIModel {
  List<UiArticle> articles;

  UiArticleList({required this.articles});
}
