import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/stitch_colors.dart';
import '../controllers/courses_controller.dart';
import 'continue_watching_card.dart';
import 'course_card.dart';

class EnrolledCoursesList extends StatelessWidget {
  final CoursesController controller;

  const EnrolledCoursesList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final continueLesson = controller.continueWatchingTarget;
      final continueCourse = controller.continueWatchingCourse;

      return Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (continueLesson != null && continueCourse != null) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled_rounded,
                          color: StitchColors.primary,
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'continue_watching'.tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: StitchColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'active_study_session'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.sp,
                        color: StitchColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ContinueWatchingCard(
                course: continueCourse,
                lesson: continueLesson,
                onTap: () => Get.toNamed<void>(
                  AppRoutes.courseDetails,
                  arguments: continueCourse,
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.video_library_rounded,
                        color: StitchColors.primary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'enrolled_courses'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: StitchColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'view_all_count'.trParams({'count': '${controller.courses.length}'}),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      color: StitchColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: controller.courses.map((course) {
                  final lessons = controller.allLessonsFor(course);
                  return CourseCard(
                    course: course,
                    progress: controller.progressFor(course),
                    lessonCount: lessons.length,
                    onTap: () => Get.toNamed<void>(
                      AppRoutes.courseDetails,
                      arguments: course,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
