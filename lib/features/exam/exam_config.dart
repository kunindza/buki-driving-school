/// Placeholder exam rules — confirm the real DDS numbers and swap these in.
class ExamConfig {
  static const questionCount = 30;
  static const durationMinutes = 30;

  /// Max wrong answers still allowed to pass — the next one fails the exam
  /// immediately, without waiting for the remaining questions to be answered.
  static const maxWrongToPass = 5;
}
