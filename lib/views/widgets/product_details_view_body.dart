import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:bike_store/views/my_shopping_cart_view.dart';
import 'package:bike_store/views/widgets/product_details_custom_bottom_sheet.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:bike_store/views/widgets/sliding_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

class ProductDetailsViewBody extends StatefulWidget {
  final ProductItem? product;

  const ProductDetailsViewBody({super.key, this.product});

  @override
  State<ProductDetailsViewBody> createState() => _ProductDetailsViewBodyState();
}

class _ProductDetailsViewBodyState extends State<ProductDetailsViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    initSlidingAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isExpanded,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isExpanded) {
          setState(() {
            isExpanded = false;
          });
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: 64,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconContainer(
                  onTap: () {
                    if (isExpanded) {
                      setState(() {
                        isExpanded = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: AnimatedRotation(
                    turns: isExpanded ? -0.25 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: SvgPicture.asset(
                      Assets.assetsImagesIconsArowwLeftIcon,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.product?.name ?? 'PEUGEOT - LR01',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bold20.copyWith(
                      letterSpacing: -0.30,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 44.w),
              ],
            ),
          ),
          Positioned(
            child: SlidingProduct(
              slidingAnimation: slidingAnimation,
              productImage:
                  widget.product?.imagePath ??
                  Assets.assetsImagesComponentRobertBicycle,
              isExpanded: isExpanded,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProductDetailsCustomBottomSheet(
              product: widget.product,
              isExpanded: isExpanded,
              onExpandedChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
              onAddToCart: () {
                Navigator.pushNamed(context, MyShoppingCartView.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    slidingAnimation = Tween<Offset>(
      begin: const Offset(-2, -0.2),
      end: Offset.zero,
    ).animate(animationController);
    animationController.forward();
  }
}
