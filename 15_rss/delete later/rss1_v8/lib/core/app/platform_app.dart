import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../generated/l10n.dart';
import '../routes/routes.dart';
import '../presentation/widgets/abstract_plaform_widget.dart';

class RickMortyApp extends AbstractPlatformWidget<CupertinoApp, MaterialApp> {
  /// Platform dependent app widget (CupertinoApp for iOS, MaterialApp for android)
  final String title;

  const RickMortyApp({Key? key, this.title = 'synopsys'}) : super(key: key);

  @override
  CupertinoApp buildCupertino(BuildContext context) {
    return CupertinoApp.router(
      routeInformationProvider: routes.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: title,
      theme: const CupertinoThemeData(),
      routeInformationParser: routes.routeInformationParser,
      routerDelegate: routes.routerDelegate,
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
    );
  }

  @override
  MaterialApp buildMaterial(BuildContext context) {
    var lightTheme =
        FlexColorScheme.light(scheme: FlexScheme.blueWhale).toTheme;
    var darkTheme = FlexColorScheme.dark(scheme: FlexScheme.blueWhale).toTheme;
    return MaterialApp.router(
      routeInformationProvider: routes.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
      title: title,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routeInformationParser: routes.routeInformationParser,
      routerDelegate: routes.routerDelegate,
    );
  }
}
