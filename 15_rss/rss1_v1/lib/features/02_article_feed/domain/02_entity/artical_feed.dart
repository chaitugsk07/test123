class Rss1Artical {
  final String? postLink;
  final String? imageLink;
  final String? title;
  final String? summary;
  final String? author;
  final String? postPublished;
  final int? isDefaultImage;
  final Rss1LinkByRss1Link? rss1LinkByRss1Link;

  Rss1Artical(
      this.postLink,
      this.imageLink,
      this.title,
      this.summary,
      this.author,
      this.postPublished,
      this.isDefaultImage,
      this.rss1LinkByRss1Link);
}

class Rss1LinkByRss1Link {
  final String? outlet;
  final String? rss1LinkName;
  final Rss1Outlet? rss1Outlet;

  Rss1LinkByRss1Link(this.outlet, this.rss1LinkName, this.rss1Outlet);
}

class Rss1Outlet {
  final String? logoUrl;
  final String? outletDisplay;

  Rss1Outlet(this.logoUrl, this.outletDisplay);
}

class Rss1ArticalList {
  final List<Rss1Artical> articalRss1List;

  Rss1ArticalList(this.articalRss1List);
}
