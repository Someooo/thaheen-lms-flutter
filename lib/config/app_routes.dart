import 'package:get/get.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: initial,
      page: () => const SplashPage(),
    ),
  ];
}
