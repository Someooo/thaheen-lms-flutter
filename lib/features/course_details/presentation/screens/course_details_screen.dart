import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../courses/domain/entities/lesson.dart';
import '../../../../config/stitch_colors.dart';
import '../controllers/course_details_controller.dart';
import '../widgets/course_details_action_strip.dart';
import '../widgets/course_details_top_bar.dart';
import '../widgets/course_hero_media_card.dart';
import '../widgets/course_syllabus_section_list.dart';
import '../widgets/locked_lesson_dialog.dart';
import '../widgets/sequential_learning_banner.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  void _handleLessonTap(
    BuildContext context,
    CourseDetailsController controller,
    Lesson lesson,
  ) {
    final unlocked = controller.unlockedFor(lesson);
    if (!unlocked) {
      LockedLessonDialog.show(context);
      return;
    }

    Get.toNamed<void>(
      '/lesson-player',
      arguments: <String, dynamic>{
        'course': controller.course,
        'lesson': lesson,
      },
    )?.then((_) => controller.refreshProgress());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailsController>();

    return Scaffold(
      backgroundColor: StitchColors.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: StitchColors.primary),
          );
        }

        final course = controller.course;

        return CustomScrollView(
          slivers: [
            const CourseDetailsTopBar(),
            const SliverToBoxAdapter(
              child: CourseDetailsActionStrip(),
            ),
            SliverToBoxAdapter(
              child: CourseHeroMediaCard(
                course: course,
                progress: controller.courseProgress,
              ),
            ),
            const SliverToBoxAdapter(
              child: SequentialLearningBanner(),
            ),
            CourseSyllabusSectionList(
              controller: controller,
              onLessonTap: _handleLessonTap,
            ),
          ],
        );
      }),
    );
  }
}
