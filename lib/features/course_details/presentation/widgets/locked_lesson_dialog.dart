import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class LockedLessonDialog extends StatelessWidget {
  const LockedLessonDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const LockedLessonDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: StitchColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.lock_rounded,
            color: StitchColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'lesson_locked_title'.tr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: StitchColors.onSurface,
            ),
          ),
        ],
      ),
      content: Text(
        'lesson_locked_message'.tr,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12.sp,
          color: StitchColors.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back<void>(),
          child: Text(
            'ok'.tr,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}
