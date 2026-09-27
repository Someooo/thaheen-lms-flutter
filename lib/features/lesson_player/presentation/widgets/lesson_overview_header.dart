import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';

class LessonOverviewHeader extends StatelessWidget {
  final LessonPlayerController controller;

  const LessonOverviewHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Obx(
            () => Text(
              controller.currentLesson.value.title,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: StitchColors.onSurface,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: StitchColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: StitchColors.cardShadow,
                blurRadius: 4.r,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: const BoxDecoration(
                      color: StitchColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: StitchColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.course.instructor,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: StitchColors.onSurface,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'instructor_title'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: StitchColors.onSurfaceVariant,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: StitchColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: StitchColors.primary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'take_note'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: StitchColors.primary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
