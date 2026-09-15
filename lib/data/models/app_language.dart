enum AppLanguage {
  georgian('ka', '🇬🇪', 'ქართული'),
  english('en', '🇬🇧', 'English'),
  russian('ru', '🇷🇺', 'Русский');

  const AppLanguage(this.code, this.flagEmoji, this.label);

  final String code;
  final String flagEmoji;
  final String label;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
