class Language {
  final int id;
  final String name;
  final String languageCode;

  Language(this.id, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "en"),
      Language(2, "Deutsch", "de"),
      Language(3, "española", "es"),
      Language(4, "हिन्दी", "hi"),
      Language(5, "తెలుగు", "te"),
    ];
  }
}
