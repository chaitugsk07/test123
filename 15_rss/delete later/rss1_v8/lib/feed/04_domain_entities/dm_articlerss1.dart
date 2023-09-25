class Rss1Article {
  final String? postLink, imageLink, title, summary, author;
  final DateTime? postPublished;
  final Rss1LinkByRss1Link? rss1LinkByRss1Link;

  Rss1Article(this.postLink, this.imageLink, this.title, this.summary,
      this.author, this.postPublished, this.rss1LinkByRss1Link);
}

class Rss1LinkByRss1Link {
  final String? outlet, rss1LinkName;

  Rss1LinkByRss1Link(this.outlet, this.rss1LinkName);
}

class Rss1ArticleList {
  final List<Rss1Article> rss1ArticleList;

  Rss1ArticleList(this.rss1ArticleList);
}
