import 'package:rss1_v2/core/utils/ui_model.dart';

class UiRss1Artical extends UIModel {
  final String postLink;
  final String imageLink;
  final String title;
  final String summary;
  final String author;
  final DateTime postPublished;
  final int isDefaultImage;
  final UiRss1LinkByRss1Link rss1LinkByRss1Link;

  UiRss1Artical(
      this.postLink,
      this.imageLink,
      this.title,
      this.summary,
      this.author,
      this.postPublished,
      this.isDefaultImage,
      this.rss1LinkByRss1Link);
}

class UiRss1LinkByRss1Link extends UIModel {
  final String outlet;
  final String rss1LinkName;
  final UiRss1Outlet rss1Outlet;

  UiRss1LinkByRss1Link(this.outlet, this.rss1LinkName, this.rss1Outlet);
}

class UiRss1Outlet {
  final String logoUrl;
  final String outletDisplay;

  UiRss1Outlet(this.logoUrl, this.outletDisplay);
}

class UiRss1ArticalList {
  final List<UiRss1Artical> rss1ArticalList;

  UiRss1ArticalList(this.rss1ArticalList);
}
