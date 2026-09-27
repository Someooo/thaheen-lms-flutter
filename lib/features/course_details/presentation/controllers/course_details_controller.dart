import 'package:get/get.dart';

import '../../../courses/data/datasources/lesson_progress_local_data_source.dart';
import '../../../courses/data/models/lesson_progress_model.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../courses/domain/entities/lesson.dart';
import '../../../courses/domain/enums/lesson_status.dart';
import '../../../courses/domain/logic/lesson_progress_logic.dart';

class CourseDetailsController extends GetxController {
  final LessonProgressLocalDataSource _progressDataSource;

  CourseDetailsController({
    required LessonProgressLocalDataSource progressDataSource,
  }) : _progressDataSource = progressDataSource;

  late final Course course;
  final RxMap<String, LessonProgressModel> progressMap =
      <String, LessonProgressModel>{}.obs;
  final RxBool isLoading = true.obs;

  late List<Lesson> _orderedLessons;

  @override
  void onInit() {
    super.onInit();
    course = Get.arguments as Course;
    _orderedLessons = course.sections
        .expand((s) => s.lessons)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    isLoading.value = true;
    try {
      final all = await _progressDataSource.getAllLessonProgress();
      progressMap.assignAll({for (final p in all) p.lessonId: p});
    } catch (_) {
      progressMap.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProgress() => _loadProgress();

  List<Lesson> get orderedLessons => _orderedLessons;

  LessonStatus statusFor(Lesson lesson) {
    return getLessonStatus(progressMap[lesson.id]);
  }

  bool unlockedFor(Lesson lesson) {
    return isLessonUnlocked(lesson, _orderedLessons, progressMap);
  }

  double get courseProgress {
    return calculateCourseProgress(_orderedLessons, progressMap);
  }
}
