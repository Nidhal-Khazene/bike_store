import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: stepper widget managing quantity increment/decrement.
// ─────────────────────────────────────────────────────────────────────────────

/// Quantity selector widget with a vibrant gradient '+' button,
/// quantity count text, and a dark slate '-' button.
class CartQuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartQuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Increment '+' button
        GestureDetector(
          onTap: onIncrement,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lightBlue.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.assetsImagesIconsAddIcon,
                width: 12.r,
                height: 12.r,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),

        // Quantity number
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            '$quantity',
            style: AppTextStyles.bold15.copyWith(color: Colors.white),
          ),
        ),

        // Decrement '-' button
        GestureDetector(
          onTap: onDecrement,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: const Color(0xFF353F54),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.assetsImagesIconsMinusIcon,
                width: 12.w,
                height: 2.h,
                colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.7),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
