import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../courses/domain/entities/lesson.dart';
import '../controllers/course_details_controller.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/section_header.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  void _handleLessonTap(
    BuildContext context,
    CourseDetailsController controller,
    Lesson lesson,
  ) {
    final unlocked = controller.unlockedFor(lesson);
    if (!unlocked) {
      _showLockedDialog(context);
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

  void _showLockedDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.lock_rounded,
                color: const Color(0xFF36A9E1), size: 22.sp),
            SizedBox(width: 8.w),
            Text(
              'lesson_locked_title'.tr,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        content: Text(
          'lesson_locked_message'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: Text(
              'ok'.tr,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: const Color(0xFF36A9E1),
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailsController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF36A9E1)),
          );
        }

        final course = controller.course;

        return CustomScrollView(
          slivers: [
            _CourseAppBar(
              course: course,
              progress: controller.courseProgress,
              theme: theme,
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, sectionIndex) {
                    final section = course.sections[sectionIndex];
                    final sectionLessons = List<Lesson>.from(section.lessons)
                      ..sort((a, b) => a.order.compareTo(b.order));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: section.title,
                          lessonCount: sectionLessons.length,
                          sectionIndex: sectionIndex,
                        ),
                        ...sectionLessons.map(
                          (lesson) => Obx(
                            () => LessonTile(
                              title: lesson.title,
                              duration: lesson.duration,
                              status: controller.statusFor(lesson),
                              isUnlocked: controller.unlockedFor(lesson),
                              onTap: () =>
                                  _handleLessonTap(context, controller, lesson),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    );
                  },
                  childCount: course.sections.length,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CourseAppBar extends StatelessWidget {
  final dynamic course;
  final double progress;
  final ThemeData theme;

  const _CourseAppBar({
    required this.course,
    required this.progress,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (progress * 100).round();

    return SliverAppBar(
      expandedHeight: 220.h,
      pinned: true,
      backgroundColor: const Color(0xFF00679A),
      leading: GestureDetector(
        onTap: () => Get.back<void>(),
        child: Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              course.thumbnail as String,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF00679A),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF00679A).withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title as String,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded,
                          color: Colors.white70, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        course.instructor as String,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 5.h,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$progressPercent%',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
