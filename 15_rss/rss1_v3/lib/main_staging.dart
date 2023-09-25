import 'package:rss1_v3/bootstrap.dart';
import 'package:rss1_v3/core/application/platform_app.dart';

const staging = 'staging';

void main() async {
  await bootstrap(() => const RickMortyApp(), staging);
}
