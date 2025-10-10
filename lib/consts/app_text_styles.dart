import 'package:flutter/material.dart';
import 'appColors.dart';
import 'app_fonts.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: AppFontWeights.semiBold,
    fontFamily: AppFonts.primaryFont,
    color: AppColors.textDark,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
    fontFamily: AppFonts.primaryFont,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.primary,
    fontFamily: AppFonts.primaryFont,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.wbackground,
    fontFamily: AppFonts.primaryFont,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 13,
    fontWeight: AppFontWeights.semiBold,
    fontFamily: AppFonts.primaryFont,
  );

  static const TextStyle error = TextStyle(
    color: AppColors.accent,
    fontSize: 14,
    fontFamily: AppFonts.primaryFont,
  );
}
