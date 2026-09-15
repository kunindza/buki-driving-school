import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import 'models/question.dart';
import 'models/subject.dart';

/// Loads question content bundled with the app (assets/data/questions.json)
/// and serves it to the UI. Content is data, not code: adding a question or
/// a subject never requires touching this class.
class QuestionRepository {
  QuestionRepository._(this.subjects, this._questions);

  final List<Subject> subjects;
  final List<Question> _questions;

  static Future<QuestionRepository> load({
    String assetPath = 'assets/data/questions.json',
  }) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final subjects = (json['subjects'] as List)
        .map((s) => Subject.fromJson(s as Map<String, dynamic>))
        .toList();
    final questions = (json['questions'] as List)
        .map((q) => Question.fromJson(q as Map<String, dynamic>))
        .toList();

    return QuestionRepository._(subjects, questions);
  }

  List<Question> questionsForCategory(String category) {
    return _questions.where((q) => q.isForCategory(category)).toList();
  }

  List<Question> questionsForSubject(String category, int subjectId) {
    return questionsForCategory(category)
        .where((q) => q.subjectId == subjectId)
        .toList();
  }

  /// Draws [count] questions at random for an exam, without repeats.
  /// Returns fewer than [count] if the category doesn't have enough yet.
  List<Question> randomExamSet(String category, int count) {
    final pool = questionsForCategory(category)..shuffle(Random());
    return pool.take(count).toList();
  }
}
