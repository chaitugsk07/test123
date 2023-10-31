import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWeb extends StatefulWidget {
  final String postLink;
  const ArticleWeb({Key? key, required this.postLink}) : super(key: key);

  @override
  State<ArticleWeb> createState() => _ArticleWebState();
}

class _ArticleWebState extends State<ArticleWeb> {
  @override
  Widget build(BuildContext context) {
    var postLink = widget.postLink;
    //String domain = postLink.substring(0, postLink.indexOf('.com') + 4);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Original Article",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(
              Theme.of(context).colorScheme.background.withOpacity(0.5))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                CircularProgressIndicator(
                  value: progress / 100,
                );
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(
            Uri.parse(postLink),
          ),
      ),
    );
  }
}
