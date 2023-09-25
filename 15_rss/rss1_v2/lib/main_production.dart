import 'package:injectable/injectable.dart';
import 'package:rss1_v2/core/application/bootstrap.dart';
import 'package:rss1_v2/core/application/platform_app.dart';

void main() async {
  await bootstrap(() => const SynopseApp(), Environment.prod);
}
