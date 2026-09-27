import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/lesson_progress_model.dart';

abstract class LessonProgressLocalDataSource {
  Future<LessonProgressModel?> getLessonProgress(String lessonId);
  Future<List<LessonProgressModel>> getAllLessonProgress();
  Future<void> saveLessonProgress(LessonProgressModel progress);
  Future<void> markLessonCompleted(String lessonId);
  Future<void> clearLessonProgress(String lessonId);
}

class LessonProgressLocalDataSourceImpl
    implements LessonProgressLocalDataSource {
  static const String boxName = 'lesson_progress';

  Box<LessonProgressModel> get _box =>
      Hive.box<LessonProgressModel>(boxName);

  @override
  Future<LessonProgressModel?> getLessonProgress(String lessonId) async {
    try {
      return _box.get(lessonId);
    } on Exception catch (e) {
      throw CacheException(message: 'Failed to read lesson progress: $e');
    }
  }

  @override
  Future<List<LessonProgressModel>> getAllLessonProgress() async {
    try {
      return _box.values.toList();
    } on Exception catch (e) {
      throw CacheException(message: 'Failed to read all lesson progress: $e');
    }
  }

  @override
  Future<void> saveLessonProgress(LessonProgressModel progress) async {
    try {
      await _box.put(progress.lessonId, progress);
    } on Exception catch (e) {
      throw CacheException(message: 'Failed to save lesson progress: $e');
    }
  }

  @override
  Future<void> markLessonCompleted(String lessonId) async {
    try {
      final existing = _box.get(lessonId);
      final updated = existing != null
          ? existing.copyWith(completed: true)
          : LessonProgressModel(
              lessonId: lessonId,
              position: 0,
              completed: true,
            );
      await _box.put(lessonId, updated);
    } on Exception catch (e) {
      throw CacheException(message: 'Failed to mark lesson completed: $e');
    }
  }

  @override
  Future<void> clearLessonProgress(String lessonId) async {
    try {
      await _box.delete(lessonId);
    } on Exception catch (e) {
      throw CacheException(message: 'Failed to clear lesson progress: $e');
    }
  }
}
