import 'package:flutter/material.dart';
import 'appColors.dart';
import 'app_fonts.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    //color: AppColors.white,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 13,
    color: AppColors.textLight,
  );

  static const TextStyle error = TextStyle(
    fontSize: 13,
    color: AppColors.accent,
  );
}
