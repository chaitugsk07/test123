import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rss1_v2/core/presentation/widgets/abstract_plaform_widget.dart';

class RmScaffold
    extends AbstractPlatformWidget<CupertinoPageScaffold, Scaffold> {
  const RmScaffold({
    super.key,
    required this.body,
    this.androidAppBar,
    this.iosNavBar,
  });

  final Widget body;
  final PreferredSizeWidget? androidAppBar;
  final ObstructingPreferredSizeWidget? iosNavBar;

  @override
  CupertinoPageScaffold buildCupertino(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
      navigationBar: iosNavBar,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: body,
      ),
    );
  }

  @override
  Scaffold buildMaterial(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: androidAppBar,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: body,
      ),
    );
  }
}
