/// Text translated into each supported language, e.g. {"ka": "...", "en": "...", "ru": "..."}.
typedef LocalizedText = Map<String, String>;

extension LocalizedTextResolve on LocalizedText {
  /// Falls back to English, then to whatever translation exists, if
  /// [languageCode] is missing for a given question.
  String resolve(String languageCode) {
    return this[languageCode] ?? this['en'] ?? values.first;
  }
}
