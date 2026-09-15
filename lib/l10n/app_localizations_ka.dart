// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'საავტომობილო სკოლა ბუკი';

  @override
  String get bySubject => 'თემების მიხედვით';

  @override
  String get allQuestions => 'ყველა კითხვა';

  @override
  String get exam => 'გამოცდა';

  @override
  String questionCounter(Object current, Object total) {
    return '$current/$total';
  }

  @override
  String get examSubmit => 'დასრულება';

  @override
  String get examResultTitle => 'გამოცდის შედეგი';

  @override
  String get examPassed => 'ჩაბარებულია';

  @override
  String get examFailed => 'ჩაიჭრა';

  @override
  String get backToHome => 'მთავარ გვერდზე დაბრუნება';

  @override
  String get noQuestionsYet =>
      'ამ კატეგორიისთვის კითხვები ჯერ არ არის ატვირთული.';
}
