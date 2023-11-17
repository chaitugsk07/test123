import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:synopse/core/localization/language.dart';
import 'package:synopse/core/theme/app_themes.dart';
import 'package:synopse/core/theme/typography.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synopse/core/localization/language_constants.dart';
import 'package:synopse/features/02_login_screens/bloc/login_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Google'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  return Animate(
                    effects: [
                      SlideEffect(
                        begin: const Offset(0, 1),
                        end: const Offset(0, 0),
                        delay: 200.microseconds,
                        duration: 1000.milliseconds,
                        curve: Curves.easeInOutCubic,
                      ),
                    ],
                    child: Container(
                      height: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.language,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Select Language',
                                  style: MyTypography.t1,
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: Language.languageList().length,
                              itemBuilder: (BuildContext context, int index) {
                                final language = Language.languageList()[index];
                                return GestureDetector(
                                  onTap: () async {
                                    Locale _locale =
                                        await setLocale(language.languageCode);
                                    MyApp.setLocale(context, _locale);
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: language.name ==
                                                translation(context).language
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    language.name,
                                                    style: MyTypography.t12
                                                        .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground
                                                          .withOpacity(0.8),
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    Icons.check,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground
                                                        .withOpacity(0.8),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                language.name,
                                                style: MyTypography.t12,
                                              )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.language,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var user = await LoginApi.loginWithGoogle();
                if (user != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuccessLogin(
                                name: user.displayName!,
                                email: user.email,
                                photoUrl: user.photoUrl ??
                                    "https://i.pravatar.cc/300",
                                hashcode: user.hashCode,
                                id: user.id,
                                ServerAuthCode: user.serverAuthCode ?? "null",
                                runtimeType: user.runtimeType,
                              )));
                }
              },
              child: Text(translation(context).language),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessLogin extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final int hashcode;
  final String id;
  final String ServerAuthCode;
  final Type runtimeType;
  const SuccessLogin(
      {Key? key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.hashcode,
      required this.id,
      required this.ServerAuthCode,
      required this.runtimeType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Success")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(photoUrl),
          Text("Name: $name"),
          Text("Email: $email"),
          Text("Hashcode: $hashcode"),
          Text("Id: $id"),
          Text("ServerAuthCode: $ServerAuthCode"),
          Text("runtimeType: $runtimeType"),
          ElevatedButton(
              onPressed: () async {
                await LoginApi.signOut();
                Navigator.of(context).pop();
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
