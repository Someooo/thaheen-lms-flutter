import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';
import '../../../../config/stitch_colors.dart';

class ContinueWatchingCard extends StatelessWidget {
  final Course course;
  final Lesson lesson;
  final VoidCallback? onTap;

  const ContinueWatchingCard({
    super.key,
    required this.course,
    required this.lesson,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: StitchColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: StitchColors.cardShadow,
              blurRadius: 16.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MediaBanner(course: course),
              const _ProgressTrack(),
              _CardDetails(course: course, lesson: lesson),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaBanner extends StatelessWidget {
  final Course course;

  const _MediaBanner({required this.course});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 160.h,
          width: double.infinity,
          child: Image.asset(
            course.thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: StitchColors.inverseSurface,
              child: Icon(
                Icons.medical_services_rounded,
                color: StitchColors.primaryFixed,
                size: 40.sp,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  StitchColors.inverseSurface.withValues(alpha: 0.2),
                  StitchColors.inverseSurface.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.h,
          right: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: StitchColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  course.title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.inverseOnSurface,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerLowest.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.offline_bolt_rounded,
                  color: StitchColors.primary,
                  size: 13.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  '1080p',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 8.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: StitchColors.onSurface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: Colors.white,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    '18:45 / 27:30',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 4.h,
      color: StitchColors.surfaceContainerHighest,
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: 0.68,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                StitchColors.primary,
                StitchColors.primaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

class _CardDetails extends StatelessWidget {
  final Course course;
  final Lesson lesson;

  const _CardDetails({
    required this.course,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.primary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            lesson.title,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            course.instructor,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.onSurfaceVariant,
              fontSize: 11.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'percent_completed'.trParams({'percent': '68'}),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.outline,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    lesson.duration,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.secondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      StitchColors.primary,
                      StitchColors.primaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: StitchColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'continue_watching'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
