import 'package:flutter_test/flutter_test.dart';
import 'package:theory_app/data/models/question.dart';
import 'package:theory_app/features/exam/exam_config.dart';
import 'package:theory_app/features/exam/exam_session.dart';

Question _question({required int id, required int correctIndex}) {
  return Question(
    id: id,
    categories: const ['B'],
    subjectId: 1,
    text: {'en': 'Question $id'},
    options: const [
      {'en': 'A'},
      {'en': 'B'},
    ],
    correctIndex: correctIndex,
  );
}

void main() {
  group('ExamSession scoring', () {
    test('counts correct and wrong answers independently', () {
      final session = ExamSession([
        _question(id: 1, correctIndex: 0),
        _question(id: 2, correctIndex: 1),
      ]);

      session.answer(0, 0); // correct
      session.answer(1, 0); // wrong (correct is 1)

      expect(session.correctCount, 1);
      expect(session.wrongCount, 1);
      expect(session.answeredCount, 2);
    });

    test('isComplete only once every question has an answer', () {
      final session = ExamSession([
        _question(id: 1, correctIndex: 0),
        _question(id: 2, correctIndex: 0),
      ]);

      expect(session.isComplete, isFalse);
      session.answer(0, 0);
      expect(session.isComplete, isFalse);
      session.answer(1, 0);
      expect(session.isComplete, isTrue);
    });

    test('passes only at or above the configured threshold', () {
      final questions = List.generate(
        ExamConfig.questionCount,
        (i) => _question(id: i, correctIndex: 0),
      );
      final session = ExamSession(questions);

      // Answer just enough correctly to sit one below the pass threshold.
      for (var i = 0; i < ExamConfig.passThreshold - 1; i++) {
        session.answer(i, 0);
      }
      expect(session.passed, isFalse);

      // One more correct answer should cross the threshold.
      session.answer(ExamConfig.passThreshold - 1, 0);
      expect(session.passed, isTrue);
    });

    test('re-answering a question overwrites the previous answer', () {
      final session = ExamSession([_question(id: 1, correctIndex: 0)]);

      session.answer(0, 1);
      expect(session.correctCount, 0);

      session.answer(0, 0);
      expect(session.correctCount, 1);
      expect(session.answeredCount, 1);
    });
  });
}
