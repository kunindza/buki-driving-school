/// Placeholder exam rules — confirm the real DDS numbers and swap these in.
class ExamConfig {
  static const questionCount = 30;
  static const durationMinutes = 30;

  /// Max wrong answers still allowed to pass.
  static const maxWrongToPass = 2;

  static int get passThreshold => questionCount - maxWrongToPass;
}
