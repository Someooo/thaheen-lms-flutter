import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_template/core/controllers/theme_controller.dart';
import 'package:my_template/core/controllers/language_controller.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/services/storage_service.dart';
import 'package:my_template/features/courses/data/datasources/lesson_progress_local_data_source.dart';
import 'package:my_template/features/courses/data/models/lesson_progress_model.dart';

Future<void> configureDependencies() async {
  await Hive.initFlutter();


  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(LessonProgressModelAdapter());
  }

  await Hive.openBox<LessonProgressModel>(
    LessonProgressLocalDataSourceImpl.boxName,
  );

  Get.put<NetworkService>(NetworkService(), permanent: true);

  Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
}
