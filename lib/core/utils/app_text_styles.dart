import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTextStyles {
  // Bold
  static TextStyle get bold15 => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle get bold17 => TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle get bold20 => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
  static TextStyle get bold26 => TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
  );
  // Meduim
  static TextStyle get medium13 => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle get medium15 => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );
  // Regular
  static TextStyle get regular => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle get regular24 => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
  );
}
