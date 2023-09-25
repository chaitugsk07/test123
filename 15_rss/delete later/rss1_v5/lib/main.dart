import 'package:injectable/injectable.dart';

import 'bootstrap.dart';
import 'main copy.dart';

void main() async {
  await bootstrap(() => const App(), Environment.dev);
}
