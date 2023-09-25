import 'package:injectable/injectable.dart';
import 'package:rss1_v3/bootstrap.dart';
import 'package:rss1_v3/core/application/platform_app.dart';

void main() async {
  await bootstrap(() => const RickMortyApp(), Environment.test);
}
