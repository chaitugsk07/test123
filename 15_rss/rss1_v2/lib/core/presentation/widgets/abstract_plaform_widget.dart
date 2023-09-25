import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AbstractPlatformWidget<C extends Widget, W extends Widget>
    extends StatelessWidget {
  const AbstractPlatformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return buildMaterial(context);
    }
    return Platform.isIOS || Platform.isMacOS
        ? buildCupertino(context)
        : buildMaterial(context);
  }

  C buildCupertino(BuildContext context) => throw UnimplementedError();

  W buildMaterial(BuildContext context) => throw UnimplementedError();
}
