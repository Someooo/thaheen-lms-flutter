import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/stitch_colors.dart';
import '../../../../core/controllers/language_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _startTransitionTimer();
  }

  void _startTransitionTimer() {
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _navigateToCourses();
      }
    });
  }

  void _navigateToCourses() {
    Get.offAllNamed(AppRoutes.courses);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode != 'en';

    return Scaffold(
      backgroundColor: StitchColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _SynapticBackgroundPainter(),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: StitchColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.offline_pin_rounded,
                                      size: 14.sp,
                                      color: StitchColors.tertiary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'synced_status'.tr,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: StitchColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final langCtrl = Get.find<LanguageController>();
                                  langCtrl.changeLanguage(isArabic ? 'en' : 'ar');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: StitchColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isArabic ? 'العربية' : 'English',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: StitchColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.translate_rounded,
                                        size: 14.sp,
                                        color: StitchColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale = 1.0 + (_pulseController.value * 0.08);
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      width: 140.r,
                                      height: 140.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: StitchColors.primaryContainer.withValues(alpha: 0.12),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 110.r,
                                    height: 110.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: StitchColors.primaryFixed.withValues(alpha: 0.25),
                                    ),
                                  ),
                                  Container(
                                    width: 88.r,
                                    height: 88.r,
                                    decoration: BoxDecoration(
                                      color: StitchColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: StitchColors.primary.withValues(alpha: 0.12),
                                          blurRadius: 18,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8.r),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.r),
                                      child: Image.asset(
                                        'assets/images/Thaheen logo.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.school_rounded,
                                          size: 40.sp,
                                          color: StitchColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: StitchColors.primaryFixed.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  size: 13.sp,
                                  color: StitchColors.onPrimaryFixedVariant,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'splash_portal_tag'.tr,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: StitchColors.onPrimaryFixedVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'splash_brand_title'.tr,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w800,
                              color: StitchColors.onSurface,
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 3.5.h,
                            margin: EdgeInsets.symmetric(vertical: 6.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              gradient: const LinearGradient(
                                colors: [
                                  StitchColors.primaryContainer,
                                  StitchColors.tertiaryContainer,
                                ],
                              ),
                            ),
                          ),
                          Text(
                            'splash_field_title'.tr,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: StitchColors.primary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'splash_desc'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12.sp,
                                height: 1.4,
                                color: StitchColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _buildPill(
                                dotColor: StitchColors.primary,
                                title: 'spec_medicine'.tr,
                              ),
                              _buildPill(
                                dotColor: StitchColors.tertiary,
                                title: 'spec_nursing'.tr,
                              ),
                              _buildPill(
                                dotColor: StitchColors.secondary,
                                title: 'spec_pharmacy'.tr,
                              ),
                              _buildPill(
                                dotColor: StitchColors.primaryContainer,
                                title: 'spec_prep'.tr,
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Container(
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              color: StitchColors.surfaceContainerLowest.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32.r,
                                      height: 32.r,
                                      decoration: BoxDecoration(
                                        color: StitchColors.tertiaryFixed,
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Icon(
                                        Icons.verified_user_rounded,
                                        size: 18.sp,
                                        color: StitchColors.onTertiaryFixedVariant,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'splash_sync_status'.tr,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: StitchColors.onSurface,
                                            ),
                                          ),
                                          Text(
                                            'splash_curriculum_status'.tr,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 10.sp,
                                              color: StitchColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: StitchColors.surfaceContainer,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        '100%',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: StitchColors.tertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: StitchColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                    onPressed: _navigateToCourses,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'splash_enter_portal'.tr,
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 16.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_done_rounded,
                        size: 14.sp,
                        color: StitchColors.tertiary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'splash_offline_compat'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: StitchColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill({required Color dotColor, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: StitchColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: StitchColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SynapticBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          StitchColors.primaryFixed.withValues(alpha: 0.45),
          StitchColors.surfaceContainer.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.35),
          radius: size.width * 0.45,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.45,
      auraPaint,
    );

    final linePaint = Paint()
      ..color = StitchColors.primaryContainer.withValues(alpha: 0.12)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.12,
        size.width,
        size.height * 0.22,
      );
    canvas.drawPath(path1, linePaint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.58,
        size.width,
        size.height * 0.45,
      );
    canvas.drawPath(path2, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
