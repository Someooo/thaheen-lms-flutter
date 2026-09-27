import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class SequentialLearningBanner extends StatelessWidget {
  const SequentialLearningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: StitchColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: const BoxDecoration(
              color: StitchColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_open_rounded,
              color: StitchColors.primary,
              size: 15.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sequential_rule_title'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSurface,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'sequential_rule_desc'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSurfaceVariant,
                    fontSize: 10.sp,
                    height: 1.35,
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
