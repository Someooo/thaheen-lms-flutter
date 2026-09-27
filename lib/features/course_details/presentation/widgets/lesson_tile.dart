import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../courses/domain/enums/lesson_status.dart';
import '../../../../config/stitch_colors.dart';

class LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final LessonStatus status;
  final bool isUnlocked;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.title,
    required this.duration,
    required this.status,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locked = !isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: locked ? 0.65 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: locked
                ? StitchColors.surfaceContainerLow
                : StitchColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: locked
                ? null
                : [
                    BoxShadow(
                      color: StitchColors.cardShadow,
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
          ),
          child: Row(
            children: [
              _LeadingIcon(status: status, locked: locked),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: locked
                            ? StitchColors.outline
                            : StitchColors.onSurface,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 11.sp,
                          color: StitchColors.outline,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          duration,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10.sp,
                            color: StitchColors.outline,
                          ),
                        ),
                        if (!locked) ...[
                          SizedBox(width: 8.w),
                          Text(
                            'saved_in_hive'.tr,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 9.sp,
                              color: StitchColors.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _StatusPill(status: status, locked: locked),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final LessonStatus status;
  final bool locked;

  const _LeadingIcon({required this.status, required this.locked});

  @override
  Widget build(BuildContext context) {
    if (locked) {
      return Container(
        width: 32.w,
        height: 32.w,
        decoration: const BoxDecoration(
          color: StitchColors.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock_rounded,
          size: 15.sp,
          color: StitchColors.outline,
        ),
      );
    }

    switch (status) {
      case LessonStatus.completed:
        return Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: StitchColors.tertiaryContainer.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 16.sp,
            color: StitchColors.tertiary,
          ),
        );
      case LessonStatus.inProgress:
        return Container(
          width: 32.w,
          height: 32.w,
          decoration: const BoxDecoration(
            color: StitchColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            size: 18.sp,
            color: StitchColors.onPrimaryFixedVariant,
          ),
        );
      case LessonStatus.notStarted:
        return Container(
          width: 32.w,
          height: 32.w,
          decoration: const BoxDecoration(
            color: StitchColors.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_circle_outline_rounded,
            size: 16.sp,
            color: StitchColors.secondary,
          ),
        );
    }
  }
}

class _StatusPill extends StatelessWidget {
  final LessonStatus status;
  final bool locked;

  const _StatusPill({required this.status, required this.locked});

  @override
  Widget build(BuildContext context) {
    if (locked) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: StitchColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 11.sp,
              color: StitchColors.outline,
            ),
            SizedBox(width: 3.w),
            Text(
              'status_locked'.tr,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: StitchColors.outline,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    switch (status) {
      case LessonStatus.completed:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: StitchColors.tertiaryFixed.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 12.sp,
                color: StitchColors.tertiary,
              ),
              SizedBox(width: 3.w),
              Text(
                'status_completed'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.tertiary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      case LessonStatus.inProgress:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: StitchColors.primaryFixed.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5.r,
                height: 5.r,
                decoration: const BoxDecoration(
                  color: StitchColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'status_in_progress'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.onPrimaryFixedVariant,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      case LessonStatus.notStarted:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: StitchColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_rounded,
                size: 11.sp,
                color: StitchColors.secondary,
              ),
              SizedBox(width: 3.w),
              Text(
                'status_ready_to_start'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.secondary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
    }
  }
}
