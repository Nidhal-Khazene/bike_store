import 'package:flutter/material.dart';

abstract class AppTextStyles {
  // Bold
  static const TextStyle bold15 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bold17 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bold20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bold26 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );
  // Meduim
  static const TextStyle medium13 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle medium15 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  // Regular
  static const TextStyle regular = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle regular24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );
}
