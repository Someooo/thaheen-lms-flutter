import 'package:get/get.dart';

import '../../data/datasources/courses_local_data_source.dart';
import '../../data/datasources/lesson_progress_local_data_source.dart';
import '../../data/models/lesson_progress_model.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/logic/lesson_progress_logic.dart';

enum CoursesViewState { loading, error, empty, success }

class CoursesController extends GetxController {
  final CoursesLocalDataSource _coursesDataSource;
  final LessonProgressLocalDataSource _progressDataSource;

  CoursesController({
    required CoursesLocalDataSource coursesDataSource,
    required LessonProgressLocalDataSource progressDataSource,
  })  : _coursesDataSource = coursesDataSource,
        _progressDataSource = progressDataSource;

  final Rx<CoursesViewState> state = CoursesViewState.loading.obs;
  final RxList<Course> courses = <Course>[].obs;
  final RxMap<String, LessonProgressModel> progressMap =
      <String, LessonProgressModel>{}.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    state.value = CoursesViewState.loading;
    try {
      final courseModels = await _coursesDataSource.getCourses();
      final allProgress = await _progressDataSource.getAllLessonProgress();

      final loadedCourses = courseModels.map((m) => m.toEntity()).toList();
      final map = {for (final p in allProgress) p.lessonId: p};

      if (loadedCourses.isEmpty) {
        state.value = CoursesViewState.empty;
      } else {
        courses.assignAll(loadedCourses);
        progressMap.assignAll(map);
        state.value = CoursesViewState.success;
      }
    } catch (_) {
      errorMessage.value = 'تعذّر تحميل الدورات. حاول مجددًا.';
      state.value = CoursesViewState.error;
    }
  }

  List<Lesson> allLessonsFor(Course course) {
    return course.sections.expand((s) => s.lessons).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  double progressFor(Course course) {
    return calculateCourseProgress(allLessonsFor(course), progressMap);
  }

  Lesson? continueWatchingLesson(Course course) {
    return getContinueWatchingLesson(allLessonsFor(course), progressMap);
  }

  Course? get continueWatchingCourse {
    for (final course in courses) {
      if (continueWatchingLesson(course) != null) return course;
    }
    return null;
  }

  Lesson? get continueWatchingTarget {
    final course = continueWatchingCourse;
    if (course == null) return null;
    return continueWatchingLesson(course);
  }
}
