// Centralized dependency registration using GetX bindings.

import 'package:get/get.dart';
import 'package:my_template/core/controllers/theme_controller.dart';
import 'package:my_template/core/controllers/language_controller.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/services/storage_service.dart';

Future<void> configureDependencies() async {
  // Global permanent service
  Get.put<NetworkService>(NetworkService(), permanent: true);

  // Lazy-loaded global services / controllers
  Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
}
