import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class CourseDetailsActionStrip extends StatelessWidget {
  const CourseDetailsActionStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: StitchColors.tertiary,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'certified_medical_content'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSurfaceVariant,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: StitchColors.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.download_for_offline_rounded,
                  color: StitchColors.onSecondaryContainer,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'download_offline_study'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSecondaryContainer,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
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
