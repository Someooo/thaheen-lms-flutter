import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/core/controllers/language_controller.dart';
import 'package:my_template/core/localization/app_translations.dart';

void main() {
  group('Localization and Translations', () {
    final translations = AppTranslations();

    test('supported locales include Arabic and English', () {
      expect(LanguageController.supportedLocales, contains(const Locale('ar')));
      expect(LanguageController.supportedLocales, contains(const Locale('en')));
    });

    test('default and fallback locale is Arabic', () {
      expect(LanguageController.defaultLocale, const Locale('ar'));
      expect(LanguageController.fallbackLocale, const Locale('ar'));
    });

    test('Arabic translation map contains all required core keys', () {
      final arKeys = translations.keys['ar']!;
      expect(arKeys['app_title'], 'ذاهين');
      expect(arKeys['my_courses'], 'دوراتي');
      expect(arKeys['continue_watching'], 'متابعة المشاهدة');
      expect(arKeys['all_courses'], 'جميع الدورات');
      expect(arKeys['retry'], 'إعادة المحاولة');
      expect(arKeys['status_completed'], 'مكتمل');
      expect(arKeys['status_locked'], 'مقفل');
      expect(arKeys['next_lesson'], 'الدرس التالي');
      expect(arKeys['playback_speed'], 'سرعة التشغيل');
      expect(arKeys['lesson_locked_title'], 'الدرس مقفل');
    });

    test('English translation map contains all corresponding keys', () {
      final enKeys = translations.keys['en']!;
      expect(enKeys['app_title'], 'Thaheen');
      expect(enKeys['my_courses'], 'My Courses');
      expect(enKeys['continue_watching'], 'Continue Watching');
      expect(enKeys['all_courses'], 'All Courses');
      expect(enKeys['retry'], 'Retry');
      expect(enKeys['status_completed'], 'Completed');
      expect(enKeys['status_locked'], 'Locked');
      expect(enKeys['next_lesson'], 'Next Lesson');
      expect(enKeys['playback_speed'], 'Playback Speed');
      expect(enKeys['lesson_locked_title'], 'Lesson Locked');
    });

    test('both languages have identical key sets', () {
      final arKeys = translations.keys['ar']!.keys.toSet();
      final enKeys = translations.keys['en']!.keys.toSet();
      expect(arKeys, equals(enKeys));
    });

    test('LanguageController falls back to Arabic for unsupported languages', () {
      final controller = LanguageController();
      expect(controller.resolveLocale(const Locale('fr')), const Locale('ar'));
      expect(controller.resolveLocale(const Locale('de')), const Locale('ar'));
      expect(controller.resolveLocale(null), const Locale('ar'));
    });

    test('LanguageController selects English when device language is English', () {
      final controller = LanguageController();
      expect(controller.resolveLocale(const Locale('en')), const Locale('en'));
      expect(controller.resolveLocale(const Locale('en', 'US')), const Locale('en'));
    });

    test('LanguageController selects Arabic when device language is Arabic', () {
      final controller = LanguageController();
      expect(controller.resolveLocale(const Locale('ar')), const Locale('ar'));
      expect(controller.resolveLocale(const Locale('ar', 'SA')), const Locale('ar'));
    });
  });
}
