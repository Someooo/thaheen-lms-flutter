import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';

class LessonMiniSyllabusTimeline extends StatelessWidget {
  final LessonPlayerController controller;

  const LessonMiniSyllabusTimeline({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Column(
        children: controller.orderedLessons.take(3).map((lesson) {
          final isCurrent = lesson.id == controller.currentLesson.value.id;
          final isCompleted =
              controller.progressMap[lesson.id]?.completed == true;

          return Container(
            margin: EdgeInsets.only(bottom: 6.h),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isCurrent
                  ? StitchColors.surfaceContainerLowest
                  : StitchColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? StitchColors.tertiaryContainer.withValues(alpha: 0.2)
                        : (isCurrent
                            ? StitchColors.primaryContainer
                            : StitchColors.surfaceContainerHighest),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : (isCurrent
                            ? Icons.play_arrow_rounded
                            : Icons.lock_outline_rounded),
                    color: isCompleted
                        ? StitchColors.tertiary
                        : (isCurrent
                            ? StitchColors.onPrimaryContainer
                            : StitchColors.outline),
                    size: 13.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isCurrent
                              ? StitchColors.primary
                              : StitchColors.onSurface,
                          fontSize: 11.sp,
                          fontWeight:
                              isCurrent ? FontWeight.w700 : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isCurrent
                            ? 'current_playing_lecture'.tr
                            : (isCompleted
                                ? 'status_completed'.tr
                                : 'next_lesson'.tr),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isCompleted
                              ? StitchColors.tertiary
                              : StitchColors.outline,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  lesson.duration,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.outline,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
