import 'package:flutter/material.dart';

/// Font Sizes
class AppFonts {
  static const double small = 12.0;
  static const double medium = 14.0;
  static const double large = 18.0;
  static const double title = 24.0;
}

/// Font Weights
class AppFontWeights {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.bold;
}

/// Field Styling for Login/Signup
class LoginSignupStyles {
  // Spacing
  static const double fieldSpacing = 15.0;
  static const double labelSpacing = 4.0;
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  // Font
  static const String fontFamily = 'Manrope';

  // Colors
  static const Color primaryColor = Colors.deepPurple;
  static const Color borderColor = Color(0xFFBDBDBD);

  // Border Radius
  static final BorderRadius borderRadius = BorderRadius.circular(10);

  // Input Borders
  static final OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: BorderSide(color: borderColor),
  );

  static const OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: primaryColor),
  );

  static const OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: primaryColor),
  );
}
