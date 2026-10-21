import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/views/home_view.dart';
import 'package:bike_store/views/widgets/cart_coupon_field.dart';
import 'package:bike_store/views/widgets/cart_item_card.dart';
import 'package:bike_store/views/widgets/cart_item_model.dart';
import 'package:bike_store/views/widgets/cart_order_summary.dart';
import 'package:bike_store/views/widgets/my_shopping_cart_app_bar.dart';
import 'package:bike_store/views/widgets/slide_to_checkout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: coordinates the cart view state, item counters,
// coupon application, order calculations, and the slide-to-checkout scenario.
// ─────────────────────────────────────────────────────────────────────────────

/// Main body widget of the My Shopping Cart view.
class MyShoppingCartViewBody extends StatefulWidget {
  const MyShoppingCartViewBody({super.key});

  @override
  State<MyShoppingCartViewBody> createState() => _MyShoppingCartViewBodyState();
}

class _MyShoppingCartViewBodyState extends State<MyShoppingCartViewBody> {
  late final List<CartItemModel> _cartItems;
  late final TextEditingController _couponController;

  bool _isDiscountApplied = false;
  bool _isCheckoutCompleted = false;

  @override
  void initState() {
    super.initState();
    _cartItems = List<CartItemModel>.from(CartItemModel.initialCartItems);
    _couponController = TextEditingController(text: 'Bike');
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  /// Calculates total subtotal across all cart items.
  double get _subtotal {
    return _cartItems.fold<double>(
      0.0,
      (total, item) => total + item.totalPrice,
    );
  }

  void _incrementQuantity(int index) {
    setState(() {
      final currentItem = _cartItems[index];
      _cartItems[index] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final currentItem = _cartItems[index];
      if (currentItem.quantity > 1) {
        _cartItems[index] = currentItem.copyWith(
          quantity: currentItem.quantity - 1,
        );
      }
    });
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isDiscountApplied = !_isDiscountApplied;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isDiscountApplied
              ? 'Coupon "$code" applied! 30% discount added.'
              : 'Coupon removed.',
          style: AppTextStyles.regular15.copyWith(color: Colors.white),
        ),
        backgroundColor: _isDiscountApplied
            ? AppColors.primary
            : const Color(0xFF353F54),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _handleCheckout() {
    setState(() {
      _isCheckoutCompleted = true;
    });

    final double finalAmount = _isDiscountApplied ? (_subtotal * 0.70) : _subtotal;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF242C3B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          title: Center(
            child: Text(
              'Order Placed!',
              style: AppTextStyles.bold20.copyWith(color: Colors.white),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 36.r,
                ),
              ),
              Gap(16.h),
              Text(
                'Total Paid: ${formatCurrency(finalAmount)}',
                style: AppTextStyles.bold17.copyWith(color: AppColors.cyan),
              ),
              Gap(8.h),
              Text(
                'Your bike gear is on its way with free delivery!',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular15.copyWith(
                  color: const Color(0xFF8A94A6),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeView.routeName,
                  (route) => false,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Back to Home',
                  style: AppTextStyles.bold15.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleResetCheckout() {
    setState(() {
      _isCheckoutCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(8.h),

          // App bar
          const MyShoppingCartAppBar(),

          Gap(24.h),

          // List of Cart Items separated by dividers
          for (int i = 0; i < _cartItems.length; i++) ...[
            CartItemCard(
              item: _cartItems[i],
              onIncrement: () => _incrementQuantity(i),
              onDecrement: () => _decrementQuantity(i),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Container(
                height: 1.0,
                color: const Color(0xFF2C3545),
              ),
            ),
          ],

          Gap(4.h),

          // Coupon code input field
          CartCouponField(
            controller: _couponController,
            onApply: _applyCoupon,
            isApplied: _isDiscountApplied,
          ),

          Gap(18.h),

          // Free shipping qualification notice
          Center(
            child: Text(
              'Your bag qualifies for free shipping',
              style: AppTextStyles.regular15.copyWith(
                color: const Color(0xFF8A94A6),
                letterSpacing: 0.2,
              ),
            ),
          ),

          Gap(20.h),

          // Order summary breakdown
          CartOrderSummary(
            subtotal: _subtotal,
            isDiscountApplied: _isDiscountApplied,
            discountPercent: 0.30,
            deliveryFee: 0.0,
          ),

          Gap(24.h),

          // Slide to checkout interactive button
          SlideToCheckoutButton(
            isCompleted: _isCheckoutCompleted,
            onCheckout: _handleCheckout,
            onReset: _handleResetCheckout,
          ),

          Gap(24.h),
        ],
      ),
    );
  }
}
