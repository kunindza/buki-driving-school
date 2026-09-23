import 'localized_text.dart';

class Question {
  const Question({
    required this.id,
    required this.categories,
    required this.subjectId,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.image,
    this.answerMedia,
    this.explanation,
  });

  final int id;
  final List<String> categories;
  final int subjectId;
  final LocalizedText text;

  /// Asset path under assets/images/questions/, or null for text-only questions.
  final String? image;

  /// Asset path under assets/images/answers/ for the animated clip shown
  /// once the question is answered (arrows recolored to the correct path),
  /// or null when only the static [image] and text explanation are available.
  final String? answerMedia;

  /// 2-4 answer options, each localized the same way as [text].
  final List<LocalizedText> options;
  final int correctIndex;
  final LocalizedText? explanation;

  bool isForCategory(String category) => categories.contains(category);

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      categories: List<String>.from(json['categories'] as List),
      subjectId: json['subjectId'] as int,
      text: Map<String, String>.from(json['text'] as Map),
      image: json['image'] as String?,
      answerMedia: json['answerMedia'] as String?,
      options: (json['options'] as List)
          .map((o) => Map<String, String>.from(o as Map))
          .toList(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] == null
          ? null
          : Map<String, String>.from(json['explanation'] as Map),
    );
  }
}
