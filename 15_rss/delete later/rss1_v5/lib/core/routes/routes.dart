import 'package:go_router/go_router.dart';

import '../../main copy.dart';

const rootRoute = '/';
const characterRoute = '/object';

final routes = GoRouter(
  routes: [feedRoute()],
);

GoRoute feedRoute() {
  return GoRoute(
    path: rootRoute,
    builder: (context, state) => const App(),
  );
}
