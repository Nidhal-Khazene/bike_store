import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// #242C3B - Dark Slate Blue / Main App Background
  static const Color background = Color(0xFF242C3B);
  static const Color darkBlue = Color(0xFF242C3B);

  /// #37B6E9 - Light Sky Blue / Cyan (Gradient start & Highlights)
  static const Color lightBlue = Color(0xFF37B6E9);
  static const Color cyan = Color(0xFF37B6E9);

  /// #4B4CED - Royal Blue / Electric Indigo (Primary Brand Color & Gradient end)
  static const Color primary = Color(0xFF4B4CED);
  static const Color royalBlue = Color(0xFF4B4CED);

  /// #353F54 - Slate Gray-Blue / Card & Component Surface
  static const Color cardColor = Color(0xFF353F54);
  static const Color slateBlue = Color(0xFF353F54);

  /// #222834 - Deep Dark Navy / Bottom Navigation Bar & Secondary Surface
  static const Color deepNavy = Color(0xFF222834);
  static const Color darkSurface = Color(0xFF222834);

  /// Linear gradient combining #37B6E9 and #4B4CED
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      lightBlue,
      primary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
