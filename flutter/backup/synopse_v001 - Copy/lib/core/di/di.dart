import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDataInjection(String env) {
  GetIt.instance.$initGetIt(environment: env);
}

void configureAppInjection(String env) {
  configureDataInjection(env);
  GetIt.instance.$initGetIt(environment: env);
}
