import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../courses/domain/enums/lesson_status.dart';

class LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final LessonStatus status;
  final bool isUnlocked;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.title,
    required this.duration,
    required this.status,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locked = !isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: locked ? 0.55 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.onTertiaryContainer,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _borderColor(status, locked),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              _StatusIcon(status: status, locked: locked),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: locked
                            ? theme.colorScheme.secondary.withValues(alpha: 0.5)
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 12.sp,
                          color: theme.colorScheme.secondary
                              .withValues(alpha: 0.6),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          duration,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _TrailingBadge(status: status, locked: locked),
            ],
          ),
        ),
      ),
    );
  }

  Color _borderColor(LessonStatus status, bool locked) {
    if (locked) return const Color(0xFFE0E0E0);
    switch (status) {
      case LessonStatus.completed:
        return const Color(0xFF4CAF50).withValues(alpha: 0.4);
      case LessonStatus.inProgress:
        return const Color(0xFF36A9E1).withValues(alpha: 0.5);
      case LessonStatus.notStarted:
        return const Color(0xFFE0E0E0);
    }
  }
}

class _StatusIcon extends StatelessWidget {
  final LessonStatus status;
  final bool locked;

  const _StatusIcon({required this.status, required this.locked});

  @override
  Widget build(BuildContext context) {
    if (locked) {
      return Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.lock_rounded, size: 18.sp, color: Colors.grey),
      );
    }

    switch (status) {
      case LessonStatus.completed:
        return Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, size: 20.sp,
              color: const Color(0xFF4CAF50)),
        );
      case LessonStatus.inProgress:
        return Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: const Color(0xFF36A9E1).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.play_arrow_rounded, size: 22.sp,
              color: const Color(0xFF36A9E1)),
        );
      case LessonStatus.notStarted:
        return Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.play_circle_outline_rounded, size: 20.sp,
              color: Colors.grey.shade500),
        );
    }
  }
}

class _TrailingBadge extends StatelessWidget {
  final LessonStatus status;
  final bool locked;

  const _TrailingBadge({required this.status, required this.locked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (locked) {
      return Text(
        'status_locked'.tr,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.grey,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    switch (status) {
      case LessonStatus.completed:
        return Text(
          'status_completed'.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF4CAF50),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        );
      case LessonStatus.inProgress:
        return Text(
          'status_in_progress'.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF36A9E1),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        );
      case LessonStatus.notStarted:
        return Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp,
          color: Colors.grey.shade400,
        );
    }
  }
}
