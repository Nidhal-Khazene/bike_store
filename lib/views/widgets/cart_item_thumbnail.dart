import 'package:bike_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: displays the rounded thumbnail card for a cart item.
// ─────────────────────────────────────────────────────────────────────────────

/// A rounded dark slate-navy card thumbnail that displays the product image.
class CartItemThumbnail extends StatelessWidget {
  final String imagePath;
  final double? size;

  const CartItemThumbnail({
    super.key,
    required this.imagePath,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveSize = size ?? 80.r;

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF384358),
            AppColors.cardColor,
          ],
        ),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
