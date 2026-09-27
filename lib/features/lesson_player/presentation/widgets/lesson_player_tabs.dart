import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class LessonPlayerTabs extends StatelessWidget {
  const LessonPlayerTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: StitchColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: StitchColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: StitchColors.cardShadow,
                    blurRadius: 2.r,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'tab_module_contents'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'tab_lecture_summary'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.onSurfaceVariant,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'tab_notes'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.onSurfaceVariant,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
