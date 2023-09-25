class Article {
  final String? postLink, imageLink, title, summary, author;
  final DateTime? postPublished;
  final Rss1Link? rss1Link;

  Article(this.postLink, this.imageLink, this.title, this.summary, this.author, this.postPublished, this.rss1Link);

}

class Rss1Link {
  final String? outlet, rss1LinkName;

  Rss1Link(this.outlet, this.rss1LinkName);

}

class ArticleFeedList {
  final List<Article> articlefeedList;

  ArticleFeedList(this.articlefeedList);
}
