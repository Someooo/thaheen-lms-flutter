import '../../../../core/localization/localized_content.dart';
import '../../domain/entities/course.dart';
import 'section_model.dart';

class CourseModel {
  final String id;
  final LocalizedContent localizedTitle;
  final LocalizedContent localizedInstructor;
  final String thumbnail;
  final List<SectionModel> sections;

  const CourseModel({
    required this.id,
    required this.localizedTitle,
    required this.localizedInstructor,
    required this.thumbnail,
    required this.sections,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final sectionList = (json['sections'] as List<dynamic>)
        .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return CourseModel(
      id: json['id'] as String,
      localizedTitle: LocalizedContent.fromJson(json['title']),
      localizedInstructor: LocalizedContent.fromJson(json['instructor']),
      thumbnail: json['thumbnail'] as String,
      sections: sectionList,
    );
  }

  Course toEntity() {
    return Course(
      id: id,
      localizedTitle: localizedTitle,
      localizedInstructor: localizedInstructor,
      thumbnail: thumbnail,
      sections: sections.map((s) => s.toEntity()).toList(),
    );
  }
}
