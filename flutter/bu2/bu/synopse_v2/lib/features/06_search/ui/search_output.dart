import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:synopse/core/utils/router.dart';
import 'package:synopse/features/06_search/ui/search_results_v1.dart';

class SeachOutPutS extends StatelessWidget {
  final int searchId;
  final String seachText;
  const SeachOutPutS({
    super.key,
    required this.searchId,
    required this.seachText,
  });

  @override
  Widget build(BuildContext context) {
    return SearchOutput(
      searchId: searchId,
      seachText: seachText,
    );
  }
}

class SearchOutput extends StatefulWidget {
  final int searchId;
  final String seachText;
  const SearchOutput({
    super.key,
    required this.searchId,
    required this.seachText,
  });

  @override
  State<SearchOutput> createState() => _SearchOutputState();
}

class _SearchOutputState extends State<SearchOutput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.push(splash);
                    }
                  },
                  child: Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 500),
                        delay: Duration(milliseconds: 300),
                      ),
                    ],
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      widget.seachText,
                    ),
                  ),
                ),
              ],
            ),
            SearchResults(
              searchID: widget.searchId,
            ),
          ],
        ),
      ),
    );
  }
}
