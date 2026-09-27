import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../courses/domain/entities/course.dart';
import '../../../courses/domain/entities/lesson.dart';
import '../../../../config/stitch_colors.dart';
import '../controllers/course_details_controller.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/section_header.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  void _handleLessonTap(
    BuildContext context,
    CourseDetailsController controller,
    Lesson lesson,
  ) {
    final unlocked = controller.unlockedFor(lesson);
    if (!unlocked) {
      _showLockedDialog(context);
      return;
    }

    Get.toNamed<void>(
      '/lesson-player',
      arguments: <String, dynamic>{
        'course': controller.course,
        'lesson': lesson,
      },
    )?.then((_) => controller.refreshProgress());
  }

  void _showLockedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailsController>();

    return Scaffold(
      backgroundColor: StitchColors.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: StitchColors.primary),
          );
        }

        final course = controller.course;

        return CustomScrollView(
          slivers: [
            _TopHeader(),
            SliverToBoxAdapter(
              child: _TopActionStrip(),
            ),
            SliverToBoxAdapter(
              child: _HeroMediaCard(
                course: course,
                progress: controller.courseProgress,
              ),
            ),
            const SliverToBoxAdapter(
              child: _SequentialLearningBanner(),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 32.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, sectionIndex) {
                    final section = course.sections[sectionIndex];
                    final sectionLessons = List<Lesson>.from(section.lessons)
                      ..sort((a, b) => a.order.compareTo(b.order));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: section.title,
                          lessonCount: sectionLessons.length,
                          sectionIndex: sectionIndex,
                        ),
                        ...sectionLessons.map(
                          (lesson) => Obx(
                            () => LessonTile(
                              title: lesson.title,
                              duration: lesson.duration,
                              status: controller.statusFor(lesson),
                              isUnlocked: controller.unlockedFor(lesson),
                              onTap: () =>
                                  _handleLessonTap(context, controller, lesson),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                      ],
                    );
                  },
                  childCount: course.sections.length,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back<void>(),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: StitchColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: StitchColors.cardShadow,
                            blurRadius: 4.r,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: StitchColors.onSurface,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Thaheen logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تفاصيل المقرر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onSurface,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: StitchColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: StitchColors.onPrimary,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopActionStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: StitchColors.tertiary,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'محتوى طبي معتمد',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSurfaceVariant,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: StitchColors.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.download_for_offline_rounded,
                  color: StitchColors.onSecondaryContainer,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'تحميل للدراسة أوفلاين',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSecondaryContainer,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
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

class _HeroMediaCard extends StatelessWidget {
  final Course course;
  final double progress;

  const _HeroMediaCard({required this.course, required this.progress});

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
                    'السنة التحضيرية والطب البشري',
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
                        'Hive Cache جاهز',
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
            'Clinical Medicine Series • Thaheen',
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
                    'أستاذ مشارك واستشاري سريري',
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
                _MetricPill(title: '16 ساعة', subtitle: 'تدريب سريري'),
                Container(
                  width: 1,
                  height: 24.h,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _MetricPill(
                  title: '$totalLessons درساً',
                  subtitle: 'محاضرة مسجلة',
                ),
                Container(
                  width: 1,
                  height: 24.h,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _MetricPill(
                  title: 'أوفلاين',
                  subtitle: 'Hive Sync',
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
                          'نسبة الإنجاز الكلية',
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

class _SequentialLearningBanner extends StatelessWidget {
  const _SequentialLearningBanner();

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
                  'قاعدة الفتح التتابعي للمحاضرات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.onSurface,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'يتطلب فتح كل درس تلقائياً استكمال 90% على الأقل من المحاضرة السابقة لضمان جودة الاستيعاب الأكاديمي.',
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
