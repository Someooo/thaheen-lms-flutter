import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/lesson_player_controller.dart';

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
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
            activeTrackColor: const Color(0xFF36A9E1),
            inactiveTrackColor: Colors.white24,
            thumbColor: const Color(0xFF36A9E1),
          ),
          child: Slider(
            value: totalMs > 0 ? clampedPos : 0.0,
            max: totalMs > 0 ? totalMs : 1.0,
            onChanged: (value) {
              controller.seekTo(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                _formatDuration(total),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white70,
                  fontSize: 11.sp,
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'سرعة التشغيل',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ...controller.availableSpeeds.map(
            (speed) {
              final isSelected = controller.currentSpeed.value == speed;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                tileColor: isSelected
                    ? const Color(0xFF36A9E1).withValues(alpha: 0.15)
                    : Colors.transparent,
                title: Text(
                  '${speed}x',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color:
                        isSelected ? const Color(0xFF36A9E1) : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded,
                        color: Color(0xFF36A9E1))
                    : null,
                onTap: () {
                  controller.setPlaybackSpeed(speed);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
