import '../../domain/entities/lesson.dart';

class LessonModel {
  final String id;
  final String title;
  final String duration;
  final String videoAsset;
  final int order;

  const LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoAsset,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      videoAsset: json['videoAsset'] as String,
      order: json['order'] as int,
    );
  }

  Lesson toEntity() {
    return Lesson(
      id: id,
      title: title,
      duration: duration,
      videoAsset: videoAsset,
      order: order,
    );
  }
}
