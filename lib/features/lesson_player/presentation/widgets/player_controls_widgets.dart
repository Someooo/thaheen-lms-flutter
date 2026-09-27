import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/lesson_player_controller.dart';
import '../../../../config/stitch_colors.dart';

class VideoProgressBar extends StatelessWidget {
  final LessonPlayerController controller;

  const VideoProgressBar({super.key, required this.controller});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final position = controller.currentPosition.value;
    final total = controller.totalDuration.value;
    final posMs = position.inMilliseconds.toDouble();
    final totalMs = total.inMilliseconds.toDouble();
    final clampedPos = posMs.clamp(0.0, totalMs > 0 ? totalMs : 0.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 10.r),
                activeTrackColor: StitchColors.primaryContainer,
                inactiveTrackColor: Colors.white24,
                thumbColor: StitchColors.primaryFixedDim,
              ),
              child: Slider(
                value: totalMs > 0 ? clampedPos : 0.0,
                max: totalMs > 0 ? totalMs : 1.0,
                onChanged: (value) {
                  controller.seekTo(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            Positioned(
              right: 28.w,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    width: 2.w,
                    height: 12.h,
                    color: StitchColors.tertiaryFixed,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  _formatDuration(position),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.primaryFixed,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.flag_rounded,
                    size: 11.sp,
                    color: StitchColors.tertiaryFixed,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    '90%',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.tertiaryFixed,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  _formatDuration(total),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.surfaceContainerHighest,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlaybackSpeedSheet extends StatelessWidget {
  final LessonPlayerController controller;

  const PlaybackSpeedSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: isLandscape ? mediaQuery.size.height * 0.85 : 360.h,
        ),
        padding: EdgeInsets.symmetric(
          vertical: isLandscape ? 12.h : 20.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: StitchColors.inverseSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'playback_speed'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.inverseOnSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: isLandscape ? 6.h : 12.h),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: controller.availableSpeeds.map(
                  (speed) {
                    final isSelected = controller.currentSpeed.value == speed;
                    return ListTile(
                      dense: isLandscape,
                      visualDensity: isLandscape
                          ? const VisualDensity(horizontal: 0, vertical: -2)
                          : VisualDensity.standard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      tileColor: isSelected
                          ? StitchColors.primary.withValues(alpha: 0.25)
                          : Colors.transparent,
                      title: Text(
                        '${speed}x',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isSelected
                              ? StitchColors.primaryFixed
                              : StitchColors.inverseOnSurface,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: StitchColors.primaryFixed,
                            )
                          : null,
                      onTap: () {
                        controller.setPlaybackSpeed(speed);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

