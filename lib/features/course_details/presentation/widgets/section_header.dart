import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int lessonCount;
  final int sectionIndex;

  const SectionHeader({
    super.key,
    required this.title,
    required this.lessonCount,
    required this.sectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    final lessonUnit =
        lessonCount == 1 ? 'unit_lesson_single'.tr : 'unit_lesson_plural'.tr;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: StitchColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '$lessonCount $lessonUnit',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: StitchColors.onSurfaceVariant,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
