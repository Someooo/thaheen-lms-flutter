import '../../domain/entities/section.dart';
import 'lesson_model.dart';

class SectionModel {
  final String id;
  final String title;
  final List<LessonModel> lessons;

  const SectionModel({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    final lessonList = (json['lessons'] as List<dynamic>)
        .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      lessons: lessonList,
    );
  }

  Section toEntity() {
    return Section(
      id: id,
      title: title,
      lessons: lessons.map((l) => l.toEntity()).toList(),
    );
  }
}
