import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/lesson_player_controller.dart';
import 'player_controls_widgets.dart';

class LessonPlayerBottomControls extends StatelessWidget {
  final LessonPlayerController controller;
  final VoidCallback onSpeedTap;

  const LessonPlayerBottomControls({
    super.key,
    required this.controller,
    required this.onSpeedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VideoProgressBar(controller: controller),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onSpeedTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Obx(
                    () => Text(
                      '${controller.currentSpeed.value}x',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  controller.isFullscreen.value
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
                onPressed: controller.toggleFullscreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
