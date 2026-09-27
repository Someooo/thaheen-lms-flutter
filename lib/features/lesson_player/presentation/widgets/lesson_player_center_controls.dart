import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';

class LessonPlayerCenterControls extends StatelessWidget {
  final LessonPlayerController controller;

  const LessonPlayerCenterControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            final current = controller.currentPosition.value;
            final target = current - const Duration(seconds: 10);
            controller.seekTo(target < Duration.zero ? Duration.zero : target);
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.replay_10_rounded,
              color: StitchColors.inverseOnSurface,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 24.w),
        GestureDetector(
          onTap: controller.togglePlayPause,
          child: Container(
            width: 52.w,
            height: 52.w,
            decoration: const BoxDecoration(
              color: StitchColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Obx(
              () => Icon(
                controller.isPlaying.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: StitchColors.onPrimaryContainer,
                size: 34.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 24.w),
        GestureDetector(
          onTap: () {
            final current = controller.currentPosition.value;
            final total = controller.totalDuration.value;
            final target = current + const Duration(seconds: 10);
            controller.seekTo(target > total ? total : target);
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.forward_10_rounded,
              color: StitchColors.inverseOnSurface,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
