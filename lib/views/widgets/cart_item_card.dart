import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/views/widgets/cart_item_model.dart';
import 'package:bike_store/views/widgets/cart_item_thumbnail.dart';
import 'package:bike_store/views/widgets/cart_quantity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: renders a single cart item row with thumbnail,
// title, unit price, and stepper.
// ─────────────────────────────────────────────────────────────────────────────

/// Individual card row for a cart item.
class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rounded slate thumbnail
        CartItemThumbnail(imagePath: item.imagePath),

        Gap(16.w),

        // Title, price and quantity stepper
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bold15.copyWith(
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              Gap(14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.priceDisplay,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.medium15.copyWith(
                        color: AppColors.cyan,
                      ),
                    ),
                  ),
                  Gap(8.w),
                  CartQuantitySelector(
                    quantity: item.quantity,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
