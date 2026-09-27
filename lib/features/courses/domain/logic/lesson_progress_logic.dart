import '../../data/models/lesson_progress_model.dart';
import '../entities/lesson.dart';
import '../enums/lesson_status.dart';

const double _completionThreshold = 0.90;

int _parseDurationSeconds(String duration) {
  final parts = duration.trim().split(':');
  if (parts.length != 2) return 0;
  final minutes = int.tryParse(parts[0]) ?? 0;
  final seconds = int.tryParse(parts[1]) ?? 0;
  if (minutes < 0 || seconds < 0) return 0;
  return (minutes * 60) + seconds;
}

LessonStatus getLessonStatus(LessonProgressModel? progress) {
  if (progress == null) return LessonStatus.notStarted;
  if (progress.completed) return LessonStatus.completed;
  if (progress.position > 0) return LessonStatus.inProgress;
  return LessonStatus.notStarted;
}

bool hasReachedCompletionThreshold(int position, String duration) {
  if (position < 0) return false;
  final totalSeconds = _parseDurationSeconds(duration);
  if (totalSeconds <= 0) return false;
  final clampedPosition = position > totalSeconds ? totalSeconds : position;
  return (clampedPosition / totalSeconds) >= _completionThreshold;
}

bool isLessonUnlocked(
  Lesson lesson,
  List<Lesson> orderedLessons,
  Map<String, LessonProgressModel> progressMap,
) {
  final index = orderedLessons.indexWhere((l) => l.id == lesson.id);
  if (index <= 0) return true;
  final previous = orderedLessons[index - 1];
  final previousProgress = progressMap[previous.id];
  return previousProgress?.completed == true;
}

double calculateCourseProgress(
  List<Lesson> lessons,
  Map<String, LessonProgressModel> progressMap,
) {
  if (lessons.isEmpty) return 0.0;
  final completedCount =
      lessons.where((l) => progressMap[l.id]?.completed == true).length;
  return completedCount / lessons.length;
}

Lesson? getContinueWatchingLesson(
  List<Lesson> orderedLessons,
  Map<String, LessonProgressModel> progressMap,
) {
  for (final lesson in orderedLessons) {
    final progress = progressMap[lesson.id];
    if (progress != null && progress.position > 0 && !progress.completed) {
      return lesson;
    }
  }
  return null;
}
