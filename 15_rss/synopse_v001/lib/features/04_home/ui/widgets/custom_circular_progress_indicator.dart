import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Opacity(
            opacity: 0.8,
            child: Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.white,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ));
  }
}
