import 'package:flutter/widgets.dart';

/// Utility helpers to determine the current form factor of the device.
class Responsive {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static double getWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isMobile(BuildContext context) => getWidth(context) < tabletBreakpoint;

  static bool isTablet(BuildContext context) =>
      getWidth(context) >= tabletBreakpoint && getWidth(context) < desktopBreakpoint;

  static bool isDesktop(BuildContext context) => getWidth(context) >= desktopBreakpoint;
}

