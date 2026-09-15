import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/app_language.dart';
import '../data/models/license_category.dart';
import '../data/question_repository.dart';

/// Loads the bundled question content once and shares it across the app.
final questionRepositoryProvider = FutureProvider<QuestionRepository>((ref) {
  return QuestionRepository.load();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('overridden in main() before runApp');
});

const _languagePrefKey = 'selected_language';
const _categoryPrefKey = 'selected_category';

/// The app's UI/content language. Defaults to Georgian until the user
/// picks another on the language gate.
class LanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() {
    final saved = ref
        .read(sharedPreferencesProvider)
        .getString(_languagePrefKey);
    return saved == null ? AppLanguage.georgian : AppLanguage.fromCode(saved);
  }

  void select(AppLanguage language) {
    state = language;
    ref
        .read(sharedPreferencesProvider)
        .setString(_languagePrefKey, language.code);
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, AppLanguage>(
  LanguageNotifier.new,
);

/// The selected license category (e.g. "B"). Always has a value so the home
/// screen has something to show; defaults to the first entry in the list.
class CategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return ref.read(sharedPreferencesProvider).getString(_categoryPrefKey) ??
        kLicenseCategories.first;
  }

  void select(String category) {
    state = category;
    ref.read(sharedPreferencesProvider).setString(_categoryPrefKey, category);
  }

  void step(int direction) {
    final count = kLicenseCategories.length;
    final i = kLicenseCategories.indexOf(state);
    final next = (i + direction + count) % count;
    select(kLicenseCategories[next]);
  }
}

final categoryProvider = NotifierProvider<CategoryNotifier, String>(
  CategoryNotifier.new,
);
