import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWeb extends StatefulWidget {
  final String postLink;
  const ArticleWeb({super.key, required this.postLink});

  @override
  State<ArticleWeb> createState() => _ArticleWebState();
}

class _ArticleWebState extends State<ArticleWeb> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.postLink));
    // #enddocregion webview_controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: WebViewWidget(controller: controller),
    );
  }
}
