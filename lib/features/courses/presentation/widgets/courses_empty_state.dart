import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class CoursesEmptyState extends StatelessWidget {
  const CoursesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 56.sp,
              color: StitchColors.outlineVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              'no_courses_available'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: StitchColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
