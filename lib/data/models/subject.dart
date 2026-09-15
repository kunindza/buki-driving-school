import 'localized_text.dart';

/// A theme/topic used by the "By Subject" mode, e.g. "Priority signs".
class Subject {
  const Subject({required this.id, required this.title});

  final int id;
  final LocalizedText title;

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      title: Map<String, String>.from(json['title'] as Map),
    );
  }
}
