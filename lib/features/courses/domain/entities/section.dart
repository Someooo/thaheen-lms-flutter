import 'lesson.dart';

class Section {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Section({
    required this.id,
    required this.title,
    required this.lessons,
  });
}
