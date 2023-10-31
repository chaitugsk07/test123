import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        child: Container(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
        baseColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
        highlightColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
      ),
    );
  }
}
