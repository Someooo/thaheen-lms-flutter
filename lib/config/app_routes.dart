import 'package:get/get.dart';
import '../features/courses/data/datasources/courses_local_data_source.dart';
import '../features/courses/data/datasources/lesson_progress_local_data_source.dart';
import '../features/courses/presentation/controllers/courses_controller.dart';
import '../features/courses/presentation/screens/courses_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String courses = '/courses';

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: initial,
      page: () => const SplashPage(),
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
  ];
}
