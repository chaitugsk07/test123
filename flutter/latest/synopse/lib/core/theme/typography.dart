import 'package:flutter/material.dart';

class MyTypography {
  static const TextStyle titleLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
//drawer
  static const TextStyle t1 = TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Noto Serif');

  static const TextStyle t12 =
      TextStyle(fontSize: 18, fontFamily: 'Noto Serif');

  static const TextStyle body = TextStyle(
    fontSize: 16,
  );
//s1 title
  static const TextStyle s1 = TextStyle(
      fontSize: 55,
      fontWeight: FontWeight.w300,
      letterSpacing: 7,
      fontFamily: 'Noto Serif');

  static const TextStyle s2 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: 'Noto Serif Condensed');

  static const TextStyle s3 =
      TextStyle(fontSize: 12, fontFamily: 'Noto Serif Condensed');

  static const TextStyle r1 = TextStyle(
      fontSize: 15, fontFamily: 'Noto Serif Condensed', color: Colors.red);

  static const TextStyle caption = TextStyle(
    fontSize: 12,
  );
}
