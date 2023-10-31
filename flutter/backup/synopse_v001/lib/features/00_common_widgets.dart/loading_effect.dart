import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.teal.shade700,
          size: 200,
          lineWidth: 3,
        ),
      ),
    );
  }
}
