import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: coupon code input field with "Apply" button.
// ─────────────────────────────────────────────────────────────────────────────

/// Input bar for entering promotional/coupon codes with a gradient "Apply" action button.
class CartCouponField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;
  final bool isApplied;

  const CartCouponField({
    super.key,
    required this.controller,
    required this.onApply,
    this.isApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2430),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Text Input for Coupon Code
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: controller,
                style: AppTextStyles.regular15.copyWith(color: Colors.white),
                cursorColor: AppColors.cyan,
                decoration: InputDecoration(
                  hintText: 'Bike',
                  hintStyle: AppTextStyles.regular15.copyWith(
                    color: const Color(0xFF8A94A6),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // "Apply" Gradient Button
          Padding(
            padding: EdgeInsets.all(3.r),
            child: GestureDetector(
              onTap: onApply,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 110.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Apply',
                    style: AppTextStyles.bold15.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
