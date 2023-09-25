import 'package:flutter/material.dart';
import 'package:rss1_v2/presentation/feed/models/ui_article_feed.dart';

buildCharactersListWidget({
  required BuildContext context,
  required TextEditingController searchTextController,
  AnimationController? animationController,
  required List<UiRss1Artical> charactersList,
  required Null Function() onScrolledToEndCallback,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: Text("abc"),
      ),
    ],
  );
}
