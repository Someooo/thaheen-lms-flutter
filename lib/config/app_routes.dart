import 'package:get/get.dart';
import '../features/course_details/presentation/controllers/course_details_controller.dart';
import '../features/course_details/presentation/screens/course_details_screen.dart';
import '../features/courses/data/datasources/courses_local_data_source.dart';
import '../features/courses/data/datasources/lesson_progress_local_data_source.dart';
import '../features/courses/presentation/controllers/courses_controller.dart';
import '../features/courses/presentation/screens/courses_screen.dart';
import '../features/lesson_player/presentation/controllers/lesson_player_controller.dart';
import '../features/lesson_player/presentation/screens/lesson_player_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String courses = '/courses';
  static const String courseDetails = '/course-details';
  static const String lessonPlayer = '/lesson-player';

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: initial,
      page: () => const SplashScreen(),
    ),
    GetPage<dynamic>(
      name: courses,
      page: () => const CoursesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CoursesController>(
          () => CoursesController(
            coursesDataSource: CoursesLocalDataSourceImpl(),
            progressDataSource: LessonProgressLocalDataSourceImpl(),
          ),
        );
      }),
    ),
    GetPage<dynamic>(
      name: courseDetails,
      page: () => const CourseDetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CourseDetailsController>(
          () => CourseDetailsController(
            progressDataSource: LessonProgressLocalDataSourceImpl(),
          ),
        );
      }),
    ),
    GetPage<dynamic>(
      name: lessonPlayer,
      page: () => const LessonPlayerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LessonPlayerController>(
          () => LessonPlayerController(
            progressDataSource: LessonProgressLocalDataSourceImpl(),
          ),
        );
      }),
    ),
  ];
}
