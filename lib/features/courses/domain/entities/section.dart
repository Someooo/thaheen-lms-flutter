import 'lesson.dart';
import '../../../../core/localization/localized_content.dart';

class Section {
  final String id;
  final LocalizedContent localizedTitle;
  final List<Lesson> lessons;

  const Section({
    required this.id,
    this.localizedTitle = const LocalizedContent(ar: '', en: ''),
    required this.lessons,
    String? title,
  }) : _title = title;

  final String? _title;

  String get title => (_title != null && _title.isNotEmpty) ? _title : localizedTitle.value;
}
