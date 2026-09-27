import 'section.dart';

class Course {
  final String id;
  final String title;
  final String instructor;
  final String thumbnail;
  final List<Section> sections;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.sections,
  });
}
