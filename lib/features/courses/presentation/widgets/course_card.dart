import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../domain/entities/course.dart';
import '../../../../config/stitch_colors.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final double progress;
  final int lessonCount;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.progress,
    required this.lessonCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (progress * 100).round();
    final lessonUnit = lessonCount == 1 ? 'unit_lesson_single'.tr : 'unit_lesson_plural'.tr;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: StitchColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: StitchColors.cardShadow,
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumbnail(
              thumbnail: course.thumbnail,
              lessonCount: lessonCount,
              lessonUnit: lessonUnit,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopMeta(),
                  SizedBox(height: 2.h),
                  Text(
                    course.title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: StitchColors.onSurface,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    course.instructor,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                      color: StitchColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  _ProgressIndicator(
                    progress: progress,
                    progressPercent: progressPercent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String thumbnail;
  final int lessonCount;
  final String lessonUnit;

  const _Thumbnail({
    required this.thumbnail,
    required this.lessonCount,
    required this.lessonUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            thumbnail,
            width: 86.w,
            height: 86.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 86.w,
              height: 86.w,
              color: StitchColors.surfaceContainerHighest,
              child: Icon(
                Icons.medical_information_rounded,
                color: StitchColors.primary,
                size: 28.sp,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4.h,
          right: 4.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: StitchColors.onSurface.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '$lessonCount $lessonUnit',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopMeta extends StatelessWidget {
  const _TopMeta();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: StitchColors.secondaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'طب بشري',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.onSecondaryContainer,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(
          Icons.cloud_done_rounded,
          color: StitchColors.tertiary,
          size: 15.sp,
        ),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;
  final int progressPercent;

  const _ProgressIndicator({
    required this.progress,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم في المقرر',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 9.sp,
                color: StitchColors.onSurfaceVariant,
              ),
            ),
            Text(
              '$progressPercent%',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: StitchColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(3.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: StitchColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation<Color>(StitchColors.primary),
            minHeight: 4.h,
          ),
        ),
      ],
    );
  }
}
