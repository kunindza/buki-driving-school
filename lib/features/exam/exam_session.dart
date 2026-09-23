import '../../data/models/question.dart';
import 'exam_config.dart';

/// Pure scoring/state logic for one exam attempt, kept free of Flutter so it
/// can be unit tested directly.
class ExamSession {
  ExamSession(this.questions) : assert(questions.isNotEmpty);

  final List<Question> questions;

  /// question index -> chosen option index.
  final Map<int, int> _answers = {};

  void answer(int questionIndex, int optionIndex) {
    _answers[questionIndex] = optionIndex;
  }

  int? answerFor(int questionIndex) => _answers[questionIndex];

  bool get isComplete => _answers.length == questions.length;

  int get answeredCount => _answers.length;

  int get correctCount {
    var count = 0;
    _answers.forEach((questionIndex, optionIndex) {
      if (questions[questionIndex].correctIndex == optionIndex) count++;
    });
    return count;
  }

  int get wrongCount => answeredCount - correctCount;

  /// True once too many wrong answers have piled up to still pass, even if
  /// the exam hasn't finished — this is checked as it happens, not just at
  /// the end, so an exam can be failed early.
  bool get failed => wrongCount > ExamConfig.maxWrongToPass;

  bool get passed => !failed && isComplete;
}
