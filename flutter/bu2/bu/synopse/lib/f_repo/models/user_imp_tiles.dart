import 'package:flutter/material.dart';
import 'package:synopse/core/theme/typography.dart';

class UserImpTile1 extends StatelessWidget {
  final String t1Number;
  final String t1Text;
  const UserImpTile1({super.key, required this.t1Number, required this.t1Text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            t1Number,
            textAlign: TextAlign.center,
            style: MyTypography.t1.copyWith(
              fontSize: 30,
            ),
          ),
          Text(
            t1Text,
            textAlign: TextAlign.center,
            style: MyTypography.t12.copyWith(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
