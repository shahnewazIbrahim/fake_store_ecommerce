import 'package:flutter/material.dart';

class AppTypography {
  static TextTheme textTheme(Brightness b) {
    final base = b == Brightness.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.4),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
