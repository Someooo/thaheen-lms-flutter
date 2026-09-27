import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/stitch_colors.dart';
import '../widgets/splash_brand_content.dart';
import '../widgets/splash_offline_footer.dart';
import '../widgets/splash_pulse_logo.dart';
import '../widgets/splash_sync_card.dart';
import '../widgets/splash_top_bar.dart';
import '../widgets/synaptic_background_painter.dart';

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
    return Scaffold(
      backgroundColor: StitchColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: SynapticBackgroundPainter(),
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
                          const SplashTopBar(),
                          SizedBox(height: 24.h),
                          SplashPulseLogo(pulseController: _pulseController),
                          SizedBox(height: 24.h),
                          const SplashBrandContent(),
                          SizedBox(height: 24.h),
                          SplashSyncCard(onEnterPortal: _navigateToCourses),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                const SplashOfflineFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
