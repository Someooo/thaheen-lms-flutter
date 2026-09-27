import '../../../../core/localization/localized_content.dart';
import '../../domain/entities/lesson.dart';

class LessonModel {
  final String id;
  final LocalizedContent localizedTitle;
  final String duration;
  final String videoAsset;
  final int order;

  const LessonModel({
    required this.id,
    required this.localizedTitle,
    required this.duration,
    required this.videoAsset,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      localizedTitle: LocalizedContent.fromJson(json['title']),
      duration: json['duration'] as String,
      videoAsset: json['videoAsset'] as String,
      order: json['order'] as int,
    );
  }

  Lesson toEntity() {
    return Lesson(
      id: id,
      localizedTitle: localizedTitle,
      duration: duration,
      videoAsset: videoAsset,
      order: order,
    );
  }
}
