import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/stitch_colors.dart';

class SplashPulseLogo extends StatelessWidget {
  final AnimationController pulseController;

  const SplashPulseLogo({super.key, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.08);
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
    );
  }
}
