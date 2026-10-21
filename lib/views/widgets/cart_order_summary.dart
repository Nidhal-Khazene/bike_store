import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: displays the price breakdown (subtotal, delivery,
// discount, total).
// ─────────────────────────────────────────────────────────────────────────────

/// Formats a numerical currency amount with thousands separators and two decimals.
String formatCurrency(double amount) {
  final parts = amount.toStringAsFixed(2).split('.');
  final integerPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return '\$$integerPart.${parts[1]}';
}

/// Price summary table widget reflecting subtotal, optional delivery fee & discount,
/// and the final total.
class CartOrderSummary extends StatelessWidget {
  final double subtotal;
  final bool isDiscountApplied;
  final double discountPercent; // e.g. 0.30 for 30%
  final double deliveryFee; // e.g. 0.0

  const CartOrderSummary({
    super.key,
    required this.subtotal,
    required this.isDiscountApplied,
    this.discountPercent = 0.30,
    this.deliveryFee = 0.0,
  });

  double get total {
    if (isDiscountApplied) {
      return (subtotal * (1.0 - discountPercent)) + deliveryFee;
    }
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Subtotal row
        _buildSummaryRow(
          label: 'Subtotal:',
          value: formatCurrency(subtotal),
        ),

        Gap(12.h),

        // Delivery Fee row (empty when not applied, matches Screen 13)
        _buildSummaryRow(
          label: 'Delivery Fee:',
          value: isDiscountApplied ? formatCurrency(deliveryFee).replaceAll('.00', '') : '',
        ),

        Gap(12.h),

        // Discount row (empty when not applied, matches Screen 13)
        _buildSummaryRow(
          label: 'Discount:',
          value: isDiscountApplied ? '${(discountPercent * 100).toInt()}%' : '',
        ),

        Gap(14.h),

        // Total row
        _buildSummaryRow(
          label: 'Total:',
          value: formatCurrency(total),
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.regular15.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.bold20.copyWith(
                  color: AppColors.cyan,
                  letterSpacing: -0.2,
                )
              : AppTextStyles.regular15.copyWith(
                  color: const Color(0xFF8A94A6),
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }
}
