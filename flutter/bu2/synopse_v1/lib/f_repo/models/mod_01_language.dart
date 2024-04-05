class LanguageElement {
  LanguageElement({
    required this.the00InternetIssue,
    required this.the04ExitApp,
    required this.the04AreYouSure,
    required this.the04ForYou,
    required this.the04Level,
    required this.the04No,
    required this.the04Search,
    required this.the04Yes,
    required this.the111SelectLanguage,
    required this.the111Submit,
    required this.languageCode,
    required this.languageEnglish,
    required this.languageNative,
  });

  final String the00InternetIssue;
  final String the04ExitApp;
  final String the04AreYouSure;
  final String the04ForYou;
  final String the04Level;
  final String the04No;
  final String the04Search;
  final String the04Yes;
  final String the111SelectLanguage;
  final String the111Submit;
  final String languageCode;
  final String languageEnglish;
  final String languageNative;

  factory LanguageElement.fromJson(Map<String, dynamic> json) {
    return LanguageElement(
      the00InternetIssue: json["00_internetIssue"] ?? "",
      the04ExitApp: json["04_ExitApp"] ?? "",
      the04AreYouSure: json["04_areYouSure"] ?? "",
      the04ForYou: json["04_forYou"] ?? "",
      the04Level: json["04_level"] ?? "",
      the04No: json["04_no"] ?? "",
      the04Search: json["04_search"] ?? "",
      the04Yes: json["04_yes"] ?? "",
      the111SelectLanguage: json["111_select_language"] ?? "",
      the111Submit: json["111_submit"] ?? "",
      languageCode: json["language_code"] ?? "",
      languageEnglish: json["language_english"] ?? "",
      languageNative: json["language_native"] ?? "",
    );
  }
}
