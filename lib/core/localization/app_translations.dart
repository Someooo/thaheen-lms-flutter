import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const Map<String, String> ar = {
    'app_title': 'ذاهين',
    'my_courses': 'دوراتي',
    'select_course_subtitle': 'اختر دورة وابدأ التعلم',
    'continue_watching': 'متابعة المشاهدة',
    'all_courses': 'جميع الدورات',
    'lesson_count_single': '@count درس',
    'lesson_count_plural': '@count دروس',
    'section_lesson_count': '@count @unit',
    'unit_lesson_single': 'درس',
    'unit_lesson_plural': 'دروس',
    'unit_lessons': 'دروس',
    'retry': 'إعادة المحاولة',
    'no_courses_available': 'لا توجد دورات متاحة حاليًا',
    'error_loading_courses': 'تعذر تحميل الدورات',
    'error_playing_video': 'تعذر تشغيل الفيديو، يرجى المحاولة مرة أخرى',
    'lesson_locked_title': 'الدرس مقفل',
    'lesson_locked_message': 'يجب إكمال الدرس السابق أولاً لفتح هذا الدرس.',
    'ok': 'حسناً',
    'status_locked': 'مقفل',
    'status_completed': 'مكتمل',
    'status_in_progress': 'جاري',
    'status_not_started': 'لم يبدأ',
    'playback_speed': 'سرعة التشغيل',
    'next_lesson': 'الدرس التالي',
    'section_prefix': 'القسم',
  };

  static const Map<String, String> en = {
    'app_title': 'Thaheen',
    'my_courses': 'My Courses',
    'select_course_subtitle': 'Select a course and start learning',
    'continue_watching': 'Continue Watching',
    'all_courses': 'All Courses',
    'lesson_count_single': '@count Lesson',
    'lesson_count_plural': '@count Lessons',
    'section_lesson_count': '@count @unit',
    'unit_lesson_single': 'Lesson',
    'unit_lesson_plural': 'Lessons',
    'unit_lessons': 'Lessons',
    'retry': 'Retry',
    'no_courses_available': 'No courses available currently',
    'error_loading_courses': 'Failed to load courses',
    'error_playing_video': 'Unable to play video, please try again',
    'lesson_locked_title': 'Lesson Locked',
    'lesson_locked_message': 'You must complete the previous lesson first to unlock this lesson.',
    'ok': 'OK',
    'status_locked': 'Locked',
    'status_completed': 'Completed',
    'status_in_progress': 'In Progress',
    'status_not_started': 'Not Started',
    'playback_speed': 'Playback Speed',
    'next_lesson': 'Next Lesson',
    'section_prefix': 'Section',
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'ar': ar,
        'ar_SA': ar,
        'en': en,
        'en_US': en,
      };
}
