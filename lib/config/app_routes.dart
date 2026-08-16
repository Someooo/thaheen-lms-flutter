import 'package:get/get.dart';
import '../features/products/presentation/bindings/products_binding.dart';
import '../features/products/presentation/screens/products_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String products = '/products';

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: initial,
      page: () => const SplashPage(),
    ),
    GetPage<dynamic>(
      name: products,
      page: () => const ProductsScreen(),
      binding: ProductsBinding(),
    ),
  ];
}
