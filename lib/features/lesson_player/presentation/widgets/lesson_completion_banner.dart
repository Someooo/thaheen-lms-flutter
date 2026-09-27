import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';

class LessonCompletionBanner extends StatelessWidget {
  final LessonPlayerController controller;

  const LessonCompletionBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isComp = controller.isCompleted.value;

      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: isComp
              ? StitchColors.tertiaryFixed.withValues(alpha: 0.2)
              : StitchColors.secondaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: isComp ? StitchColors.tertiary : StitchColors.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                isComp ? Icons.check_circle_rounded : Icons.verified_rounded,
                color: Colors.white,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isComp
                            ? 'auto_complete_success_title'.tr
                            : 'auto_complete_target_title'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isComp
                              ? StitchColors.tertiary
                              : StitchColors.onSecondaryContainer,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isComp
                              ? StitchColors.tertiary
                              : StitchColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          isComp ? 'status_completed'.tr : 'status_active'.tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isComp
                        ? 'auto_complete_success_desc'.tr
                        : 'auto_complete_target_desc'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isComp
                          ? StitchColors.onTertiaryFixedVariant
                          : StitchColors.onSecondaryContainer,
                      fontSize: 10.sp,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
