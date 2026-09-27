import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';

class LessonPlayerBottomBar extends StatelessWidget {
  final LessonPlayerController controller;

  const LessonPlayerBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Column(
        children: [
          Obx(() {
            final next = controller.nextLesson;
            final isUnlocked = controller.isNextLessonUnlocked;

            if (next == null) return const SizedBox.shrink();

            return GestureDetector(
              onTap: isUnlocked ? controller.playNextLesson : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? const LinearGradient(
                          colors: [
                            StitchColors.primary,
                            StitchColors.primaryContainer,
                          ],
                        )
                      : null,
                  color: isUnlocked ? null : StitchColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: StitchColors.primary.withValues(alpha: 0.25),
                            blurRadius: 8.r,
                            offset: Offset(0, 3.h),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.skip_next_rounded,
                          color: isUnlocked ? Colors.white : StitchColors.outline,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'next_lesson'.tr,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: isUnlocked
                                    ? Colors.white70
                                    : StitchColors.outline,
                                fontSize: 9.sp,
                              ),
                            ),
                            Text(
                              next.title,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: isUnlocked
                                    ? Colors.white
                                    : StitchColors.outline,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isUnlocked ? Colors.white : StitchColors.outline,
                      size: 13.sp,
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.download_done_rounded,
                      color: StitchColors.tertiary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'stored_in_hive_memory'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: StitchColors.onSurfaceVariant,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  'status_ready'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.tertiary,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
