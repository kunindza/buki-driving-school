// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BUKI Driving School';

  @override
  String get bySubject => 'By Subject';

  @override
  String get allQuestions => 'All Questions';

  @override
  String get exam => 'Exam';

  @override
  String questionCounter(Object current, Object total) {
    return '$current/$total';
  }

  @override
  String get examSubmit => 'Finish exam';

  @override
  String get examResultTitle => 'Exam result';

  @override
  String get examPassed => 'Passed';

  @override
  String get examFailed => 'Not passed';

  @override
  String get examCorrectLabel => 'correct';

  @override
  String get examWrongLabel => 'wrong';

  @override
  String get backToHome => 'Back to home';

  @override
  String get noQuestionsYet => 'No questions loaded for this category yet.';
}
