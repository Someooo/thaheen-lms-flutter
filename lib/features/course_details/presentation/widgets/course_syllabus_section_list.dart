import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../courses/domain/entities/lesson.dart';
import '../controllers/course_details_controller.dart';
import 'lesson_tile.dart';
import 'section_header.dart';

class CourseSyllabusSectionList extends StatelessWidget {
  final CourseDetailsController controller;
  final void Function(BuildContext context, CourseDetailsController controller, Lesson lesson) onLessonTap;

  const CourseSyllabusSectionList({
    super.key,
    required this.controller,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    final course = controller.course;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 32.h),
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
                      onTap: () => onLessonTap(context, controller, lesson),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
              ],
            );
          },
          childCount: course.sections.length,
        ),
      ),
    );
  }
}
