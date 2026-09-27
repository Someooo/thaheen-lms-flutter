import '../../../../core/localization/localized_content.dart';

class Lesson {
  final String id;
  final LocalizedContent localizedTitle;
  final String duration;
  final String videoAsset;
  final int order;

  const Lesson({
    required this.id,
    this.localizedTitle = const LocalizedContent(ar: '', en: ''),
    required this.duration,
    required this.videoAsset,
    required this.order,
    String? title,
  }) : _title = title;

  final String? _title;

  String get title => (_title != null && _title.isNotEmpty) ? _title : localizedTitle.value;
}
