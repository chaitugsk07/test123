class LanguageElement {
  LanguageElement({
    required this.the00InternetIssue,
    required this.the111SelectLanguage,
    required this.the111Submit,
    required this.languageCode,
    required this.languageEnglish,
    required this.languageNative,
  });

  final String the00InternetIssue;
  final String the111SelectLanguage;
  final String the111Submit;
  final String languageCode;
  final String languageEnglish;
  final String languageNative;

  factory LanguageElement.fromJson(Map<String, dynamic> json) {
    return LanguageElement(
      the00InternetIssue: json["00_internetIssue"] ?? "",
      the111SelectLanguage: json["111_select_language"] ?? "",
      the111Submit: json["111_submit"] ?? "",
      languageCode: json["language_code"] ?? "",
      languageEnglish: json["language_english"] ?? "",
      languageNative: json["language_native"] ?? "",
    );
  }
}
