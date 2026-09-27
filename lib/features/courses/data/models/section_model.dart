import '../../../../core/localization/localized_content.dart';
import '../../domain/entities/section.dart';
import 'lesson_model.dart';

class SectionModel {
  final String id;
  final LocalizedContent localizedTitle;
  final List<LessonModel> lessons;

  const SectionModel({
    required this.id,
    required this.localizedTitle,
    required this.lessons,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    final lessonList = (json['lessons'] as List<dynamic>)
        .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SectionModel(
      id: json['id'] as String,
      localizedTitle: LocalizedContent.fromJson(json['title']),
      lessons: lessonList,
    );
  }

  Section toEntity() {
    return Section(
      id: id,
      localizedTitle: localizedTitle,
      lessons: lessons.map((l) => l.toEntity()).toList(),
    );
  }
}
