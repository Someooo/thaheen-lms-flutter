import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../domain/entities/course.dart';

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
    final theme = Theme.of(context);
    final progressPercent = (progress * 100).round();
    final lessonUnit = lessonCount == 1 ? 'unit_lesson_single'.tr : 'unit_lesson_plural'.tr;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  course.thumbnail,
                  width: 90.w,
                  height: 90.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 90.w,
                    height: 90.h,
                    color: const Color(0xFF36A9E1).withValues(alpha: 0.15),
                    child: Icon(
                      Icons.school_rounded,
                      color: const Color(0xFF36A9E1),
                      size: 36.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14.sp,
                          color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          course.instructor,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.play_lesson_outlined,
                          size: 14.sp,
                          color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'section_lesson_count'.trParams({
                            'count': '$lessonCount',
                            'unit': lessonUnit,
                          }),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  const Color(0xFF36A9E1).withValues(alpha: 0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF36A9E1),
                              ),
                              minHeight: 5.h,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '$progressPercent%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF36A9E1),
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
