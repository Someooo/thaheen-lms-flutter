import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  static const Locale defaultLocale = Locale('ar');
  static const Locale fallbackLocale = Locale('ar');

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  Locale resolveLocale(Locale? deviceLocale) {
    if (deviceLocale != null && deviceLocale.languageCode == 'en') {
      return const Locale('en');
    }
    return defaultLocale;
  }

  Locale get locale => resolveLocale(Get.deviceLocale);

  void changeLanguage(String languageCode) {
    final target = Locale(languageCode);
    Get.updateLocale(target);
  }
}
