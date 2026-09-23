// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Автошкола БУКИ';

  @override
  String get bySubject => 'По темам';

  @override
  String get allQuestions => 'Все вопросы';

  @override
  String get exam => 'Экзамен';

  @override
  String questionCounter(Object current, Object total) {
    return '$current/$total';
  }

  @override
  String get examSubmit => 'Завершить экзамен';

  @override
  String get examResultTitle => 'Результат экзамена';

  @override
  String get examPassed => 'Сдано';

  @override
  String get examFailed => 'Не сдано';

  @override
  String get examCorrectLabel => 'верно';

  @override
  String get examWrongLabel => 'неверно';

  @override
  String get backToHome => 'На главную';

  @override
  String get noQuestionsYet => 'Для этой категории пока нет вопросов.';
}
