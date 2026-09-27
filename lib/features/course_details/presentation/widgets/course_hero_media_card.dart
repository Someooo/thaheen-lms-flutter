import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../courses/domain/entities/course.dart';
import '../../../../config/stitch_colors.dart';

class CourseHeroMediaCard extends StatelessWidget {
  final Course course;
  final double progress;

  const CourseHeroMediaCard({
    super.key,
    required this.course,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (progress * 100).round();
    final totalLessons = course.sections.fold<int>(
      0,
      (sum, s) => sum + s.lessons.length,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: StitchColors.inverseSurface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: StitchColors.inverseSurface.withValues(alpha: 0.3),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  height: 140.h,
                  width: double.infinity,
                  child: Image.asset(
                    course.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: StitchColors.onPrimaryContainer,
                      child: Icon(
                        Icons.school_rounded,
                        color: StitchColors.primaryFixed,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        StitchColors.inverseSurface.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: StitchColors.primaryContainer.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'prep_year_medicine'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onPrimaryContainer,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: StitchColors.inverseSurface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_done_rounded,
                        color: StitchColors.tertiaryFixed,
                        size: 11.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'hive_cache_ready'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: StitchColors.inverseOnSurface,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            course.title,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.inverseOnSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          Text(
            'series_subtitle'.tr,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.outlineVariant,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: const BoxDecoration(
                  color: StitchColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: StitchColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        course.instructor,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: StitchColors.inverseOnSurface,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.check_circle_rounded,
                        color: StitchColors.primaryFixed,
                        size: 12.sp,
                      ),
                    ],
                  ),
                  Text(
                    'instructor_title'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.outlineVariant,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricPill(
                  title: 'hours_stat_value'.tr,
                  subtitle: 'hours_stat_label'.tr,
                ),
                Container(
                  width: 1,
                  height: 24.h,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _MetricPill(
                  title: '$totalLessons',
                  subtitle: 'lectures_stat_label'.tr,
                ),
                Container(
                  width: 1,
                  height: 24.h,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _MetricPill(
                  title: 'offline_stat_value'.tr,
                  subtitle: 'offline_stat_label'.tr,
                  highlightColor: StitchColors.tertiaryFixed,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'overall_progress'.tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: StitchColors.inverseOnSurface,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '$progressPercent%',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: StitchColors.primaryFixed,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          StitchColors.tertiaryContainer,
                        ),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              _CircularRingProgress(progress: progress),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? highlightColor;

  const _MetricPill({
    required this.title,
    required this.subtitle,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: highlightColor ?? StitchColors.primaryFixedDim,
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: StitchColors.outlineVariant,
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }
}

class _CircularRingProgress extends StatelessWidget {
  final double progress;

  const _CircularRingProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 44.w,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: StitchColors.tertiaryFixed,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = StitchColors.tertiaryContainer
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
