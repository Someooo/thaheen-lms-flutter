import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/config/app_theme.dart';
import 'package:my_template/core/controllers/language_controller.dart';
import 'package:my_template/core/controllers/theme_controller.dart';
import 'package:my_template/core/localization/app_translations.dart';
import 'package:my_template/core/widgets/connectivity_banner_widget.dart';

class AppEntrypoint extends StatelessWidget {
  const AppEntrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Thaheen',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initial,
          getPages: AppRoutes.pages,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: Get.find<ThemeController>().themeMode,
          translations: AppTranslations(),
          locale: Get.find<LanguageController>().locale,
          fallbackLocale: LanguageController.fallbackLocale,
          supportedLocales: LanguageController.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  const ConnectivityBannerWidget(),
                  Expanded(child: child ?? const SizedBox()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

