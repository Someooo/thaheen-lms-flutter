import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';

class LessonPlayerTopBar extends StatelessWidget {
  final LessonPlayerController controller;

  const LessonPlayerTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.isFullscreen.value) {
                controller.exitFullscreen();
              } else {
                Get.back<void>();
              }
            },
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: StitchColors.inverseSurface.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: StitchColors.inverseOnSurface,
                size: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.currentLesson.value.title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.inverseOnSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'works_offline'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.tertiaryFixed,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '1080p',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: StitchColors.primaryFixed,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
