import 'package:flutter/material.dart';
import 'package:synopse/features/00_common_widgets/page_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoInternetSnackBar extends StatelessWidget {
  const NoInternetSnackBar({
    super.key,
    required this.context,
  });

  final BuildContext context;
  Future<String> getNoInternetMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('noInternetMessage') ??
        'There is issue please check internet connection';
  }

  @override
  Widget build(BuildContext context) {
    getNoInternetMessage().then((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
          ),
        ),
      );
    });

    return const Center(
      child: PageLoading(),
    );
  }
}
