import 'section.dart';
import '../../../../core/localization/localized_content.dart';

class Course {
  final String id;
  final LocalizedContent localizedTitle;
  final LocalizedContent localizedInstructor;
  final String thumbnail;
  final List<Section> sections;

  const Course({
    required this.id,
    this.localizedTitle = const LocalizedContent(ar: '', en: ''),
    this.localizedInstructor = const LocalizedContent(ar: '', en: ''),
    required this.thumbnail,
    required this.sections,
    String? title,
    String? instructor,
  })  : _title = title,
        _instructor = instructor;

  final String? _title;
  final String? _instructor;

  String get title => (_title != null && _title.isNotEmpty) ? _title : localizedTitle.value;
  String get instructor => (_instructor != null && _instructor.isNotEmpty) ? _instructor : localizedInstructor.value;
}
