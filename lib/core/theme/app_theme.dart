import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:fakestore_modern/core/theme/theme.dart';

class AppTheme {
  static ThemeData light() {
    final cs = ColorScheme.fromSeed(seedColor: AppColors.teal600);
    return ThemeData(
      colorScheme: cs,
      useMaterial3: true,
      textTheme: AppTypography.textTheme(Brightness.light),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }

  static ThemeData dark() {
    final cs = ColorScheme.fromSeed(seedColor: AppColors.teal600, brightness: Brightness.dark);
    return ThemeData(
      colorScheme: cs,
      useMaterial3: true,
      textTheme: AppTypography.textTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
