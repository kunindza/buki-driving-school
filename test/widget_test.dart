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

    test(
      'passes once every question is answered within the wrong-answer limit',
      () {
        final questions = List.generate(
          ExamConfig.questionCount,
          (i) => _question(id: i, correctIndex: 0),
        );
        final session = ExamSession(questions);

        for (var i = 0; i < ExamConfig.maxWrongToPass; i++) {
          session.answer(i, 1); // wrong
        }
        for (var i = ExamConfig.maxWrongToPass; i < questions.length; i++) {
          session.answer(i, 0); // correct
        }

        expect(session.wrongCount, ExamConfig.maxWrongToPass);
        expect(session.passed, isTrue);
      },
    );

    test('fails as soon as wrong answers exceed the limit, even mid-exam', () {
      final questions = List.generate(
        ExamConfig.questionCount,
        (i) => _question(id: i, correctIndex: 0),
      );
      final session = ExamSession(questions);

      for (var i = 0; i <= ExamConfig.maxWrongToPass; i++) {
        session.answer(i, 1); // wrong
      }

      expect(session.isComplete, isFalse);
      expect(session.failed, isTrue);
      expect(session.passed, isFalse);
    });

    test('does not pass an incomplete exam even with no wrong answers', () {
      final session = ExamSession([
        _question(id: 1, correctIndex: 0),
        _question(id: 2, correctIndex: 0),
      ]);

      session.answer(0, 0);

      expect(session.failed, isFalse);
      expect(session.passed, isFalse);
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
