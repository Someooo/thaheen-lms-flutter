import 'package:flutter_test/flutter_test.dart';
import 'package:my_template/features/courses/data/models/lesson_progress_model.dart';
import 'package:my_template/features/courses/domain/entities/lesson.dart';
import 'package:my_template/features/courses/domain/enums/lesson_status.dart';
import 'package:my_template/features/courses/domain/logic/lesson_progress_logic.dart';

void main() {
  group('hasReachedCompletionThreshold (90% completion rule)', () {
    test('returns false when position is below 90 percent', () {
      final result = hasReachedCompletionThreshold(89, '01:40');
      expect(result, isFalse);
    });

    test('returns true when position reaches exactly 90 percent', () {
      final result = hasReachedCompletionThreshold(90, '01:40');
      expect(result, isTrue);
    });

    test('returns true when position is above 90 percent', () {
      final result = hasReachedCompletionThreshold(95, '01:40');
      expect(result, isTrue);
    });

    test('returns true when position reaches 100 percent of duration', () {
      final result = hasReachedCompletionThreshold(100, '01:40');
      expect(result, isTrue);
    });

    test('returns true when position exceeds duration', () {
      final result = hasReachedCompletionThreshold(120, '01:40');
      expect(result, isTrue);
    });

    test('returns false safely when duration is zero', () {
      final result = hasReachedCompletionThreshold(10, '00:00');
      expect(result, isFalse);
    });

    test('returns false when position is negative', () {
      final result = hasReachedCompletionThreshold(-5, '01:40');
      expect(result, isFalse);
    });

    test('returns false for malformed duration string', () {
      final result = hasReachedCompletionThreshold(50, 'invalid');
      expect(result, isFalse);
    });

    test('evaluates short lesson duration accurately', () {
      expect(hasReachedCompletionThreshold(17, '00:20'), isFalse);
      expect(hasReachedCompletionThreshold(18, '00:20'), isTrue);
    });
  });

  group('getLessonStatus', () {
    test('returns notStarted when progress model is null', () {
      final status = getLessonStatus(null);
      expect(status, LessonStatus.notStarted);
    });

    test('returns notStarted when position is 0 and not completed', () {
      const model = LessonProgressModel(
        lessonId: 'l1',
        position: 0,
        completed: false,
      );
      final status = getLessonStatus(model);
      expect(status, LessonStatus.notStarted);
    });

    test('returns inProgress when position is greater than 0 and not completed',
        () {
      const model = LessonProgressModel(
        lessonId: 'l1',
        position: 25,
        completed: false,
      );
      final status = getLessonStatus(model);
      expect(status, LessonStatus.inProgress);
    });

    test('returns completed when completed is true', () {
      const model = LessonProgressModel(
        lessonId: 'l1',
        position: 95,
        completed: true,
      );
      final status = getLessonStatus(model);
      expect(status, LessonStatus.completed);
    });

    test('returns completed when completed is true even if position is 0', () {
      const model = LessonProgressModel(
        lessonId: 'l1',
        position: 0,
        completed: true,
      );
      final status = getLessonStatus(model);
      expect(status, LessonStatus.completed);
    });
  });

  group('isLessonUnlocked (sequential lesson unlock logic)', () {
    const lesson1 = Lesson(
      id: 'l1',
      title: 'Lesson 1',
      duration: '01:00',
      videoAsset: 'assets/videos/v1.mp4',
      order: 1,
    );
    const lesson2 = Lesson(
      id: 'l2',
      title: 'Lesson 2',
      duration: '01:00',
      videoAsset: 'assets/videos/v2.mp4',
      order: 2,
    );
    const lesson3 = Lesson(
      id: 'l3',
      title: 'Lesson 3',
      duration: '01:00',
      videoAsset: 'assets/videos/v3.mp4',
      order: 3,
    );
    const lesson4 = Lesson(
      id: 'l4',
      title: 'Lesson 4',
      duration: '01:00',
      videoAsset: 'assets/videos/v4.mp4',
      order: 4,
    );

    final orderedLessons = [lesson1, lesson2, lesson3, lesson4];

    test('first lesson is always unlocked regardless of progress', () {
      final unlocked = isLessonUnlocked(lesson1, orderedLessons, {});
      expect(unlocked, isTrue);
    });

    test('second lesson is locked before first lesson is completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 30,
          completed: false,
        ),
      };
      final unlocked = isLessonUnlocked(lesson2, orderedLessons, progressMap);
      expect(unlocked, isFalse);
    });

    test('second lesson is unlocked after first lesson is completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
      };
      final unlocked = isLessonUnlocked(lesson2, orderedLessons, progressMap);
      expect(unlocked, isTrue);
    });

    test('third lesson remains locked when second lesson is not completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 20,
          completed: false,
        ),
      };
      final unlocked = isLessonUnlocked(lesson3, orderedLessons, progressMap);
      expect(unlocked, isFalse);
    });

    test('third lesson unlocks when second lesson is completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 60,
          completed: true,
        ),
      };
      final unlocked = isLessonUnlocked(lesson3, orderedLessons, progressMap);
      expect(unlocked, isTrue);
    });

    test('cannot skip prerequisites: lesson 3 is locked if lesson 2 is incomplete even if lesson 1 is complete', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
      };
      final unlocked = isLessonUnlocked(lesson3, orderedLessons, progressMap);
      expect(unlocked, isFalse);
    });
  });

  group('Cross-section unlocking', () {
    const section1Lesson1 = Lesson(
      id: 's1_l1',
      title: 'Section 1 Lesson 1',
      duration: '01:00',
      videoAsset: 'assets/videos/v1.mp4',
      order: 1,
    );
    const section1Lesson2 = Lesson(
      id: 's1_l2',
      title: 'Section 1 Lesson 2',
      duration: '01:00',
      videoAsset: 'assets/videos/v2.mp4',
      order: 2,
    );
    const section2Lesson3 = Lesson(
      id: 's2_l3',
      title: 'Section 2 Lesson 3',
      duration: '01:00',
      videoAsset: 'assets/videos/v3.mp4',
      order: 3,
    );
    const section2Lesson4 = Lesson(
      id: 's2_l4',
      title: 'Section 2 Lesson 4',
      duration: '01:00',
      videoAsset: 'assets/videos/v4.mp4',
      order: 4,
    );

    final flattenedLessons = [
      section1Lesson1,
      section1Lesson2,
      section2Lesson3,
      section2Lesson4,
    ];

    test('first lesson of section 2 remains locked until last lesson of section 1 completes', () {
      final progressMap = {
        's1_l1': const LessonProgressModel(
          lessonId: 's1_l1',
          position: 60,
          completed: true,
        ),
        's1_l2': const LessonProgressModel(
          lessonId: 's1_l2',
          position: 40,
          completed: false,
        ),
      };
      final unlocked = isLessonUnlocked(section2Lesson3, flattenedLessons, progressMap);
      expect(unlocked, isFalse);
    });

    test('first lesson of section 2 unlocks once last lesson of section 1 completes', () {
      final progressMap = {
        's1_l1': const LessonProgressModel(
          lessonId: 's1_l1',
          position: 60,
          completed: true,
        ),
        's1_l2': const LessonProgressModel(
          lessonId: 's1_l2',
          position: 60,
          completed: true,
        ),
      };
      final unlocked = isLessonUnlocked(section2Lesson3, flattenedLessons, progressMap);
      expect(unlocked, isTrue);
    });
  });

  group('calculateCourseProgress', () {
    const lesson1 = Lesson(
      id: 'l1',
      title: 'Lesson 1',
      duration: '01:00',
      videoAsset: 'assets/videos/v1.mp4',
      order: 1,
    );
    const lesson2 = Lesson(
      id: 'l2',
      title: 'Lesson 2',
      duration: '01:00',
      videoAsset: 'assets/videos/v2.mp4',
      order: 2,
    );
    const lesson3 = Lesson(
      id: 'l3',
      title: 'Lesson 3',
      duration: '01:00',
      videoAsset: 'assets/videos/v3.mp4',
      order: 3,
    );
    const lesson4 = Lesson(
      id: 'l4',
      title: 'Lesson 4',
      duration: '01:00',
      videoAsset: 'assets/videos/v4.mp4',
      order: 4,
    );

    final fourLessons = [lesson1, lesson2, lesson3, lesson4];

    test('returns 0.0 when 0 lessons are completed', () {
      final progress = calculateCourseProgress(fourLessons, {});
      expect(progress, 0.0);
    });

    test('returns 0.25 when 1 of 4 lessons is completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
      };
      final progress = calculateCourseProgress(fourLessons, progressMap);
      expect(progress, 0.25);
    });

    test('returns 0.50 when 2 of 4 lessons are completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 60,
          completed: true,
        ),
      };
      final progress = calculateCourseProgress(fourLessons, progressMap);
      expect(progress, 0.50);
    });

    test('returns 0.75 when 3 of 4 lessons are completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 60,
          completed: true,
        ),
        'l3': const LessonProgressModel(
          lessonId: 'l3',
          position: 60,
          completed: true,
        ),
      };
      final progress = calculateCourseProgress(fourLessons, progressMap);
      expect(progress, 0.75);
    });

    test('returns 1.0 when all 4 lessons are completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 60,
          completed: true,
        ),
        'l3': const LessonProgressModel(
          lessonId: 'l3',
          position: 60,
          completed: true,
        ),
        'l4': const LessonProgressModel(
          lessonId: 'l4',
          position: 60,
          completed: true,
        ),
      };
      final progress = calculateCourseProgress(fourLessons, progressMap);
      expect(progress, 1.0);
    });

    test('returns 0.0 for an empty course without division-by-zero error', () {
      final progress = calculateCourseProgress([], {});
      expect(progress, 0.0);
    });

    test('ignores lessons marked incomplete even with non-zero position', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 55,
          completed: false,
        ),
      };
      final progress = calculateCourseProgress(fourLessons, progressMap);
      expect(progress, 0.0);
    });
  });

  group('getContinueWatchingLesson', () {
    const lesson1 = Lesson(
      id: 'l1',
      title: 'Lesson 1',
      duration: '01:00',
      videoAsset: 'assets/videos/v1.mp4',
      order: 1,
    );
    const lesson2 = Lesson(
      id: 'l2',
      title: 'Lesson 2',
      duration: '01:00',
      videoAsset: 'assets/videos/v2.mp4',
      order: 2,
    );
    const lesson3 = Lesson(
      id: 'l3',
      title: 'Lesson 3',
      duration: '01:00',
      videoAsset: 'assets/videos/v3.mp4',
      order: 3,
    );

    final ordered = [lesson1, lesson2, lesson3];

    test('returns null when no progress exists', () {
      final result = getContinueWatchingLesson(ordered, {});
      expect(result, isNull);
    });

    test('returns null when all started lessons are completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
      };
      final result = getContinueWatchingLesson(ordered, progressMap);
      expect(result, isNull);
    });

    test('returns the single in-progress lesson', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 60,
          completed: true,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 25,
          completed: false,
        ),
      };
      final result = getContinueWatchingLesson(ordered, progressMap);
      expect(result?.id, 'l2');
    });

    test('returns the first in-progress lesson in course order when multiple exist', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 15,
          completed: false,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 30,
          completed: false,
        ),
      };
      final result = getContinueWatchingLesson(ordered, progressMap);
      expect(result?.id, 'l1');
    });

    test('ignores lessons with 0 position that are not completed', () {
      final progressMap = {
        'l1': const LessonProgressModel(
          lessonId: 'l1',
          position: 0,
          completed: false,
        ),
        'l2': const LessonProgressModel(
          lessonId: 'l2',
          position: 40,
          completed: false,
        ),
      };
      final result = getContinueWatchingLesson(ordered, progressMap);
      expect(result?.id, 'l2');
    });
  });
}
