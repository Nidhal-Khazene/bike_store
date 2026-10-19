import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:bike_store/views/widgets/sliding_product.dart';
import 'package:flutter/material.dart';
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
    return Stack(
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
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(Assets.assetsImagesIconsArowwLeftIcon),
              ),
              Text(
                'PEUGEOT - LR01',
                style: AppTextStyles.bold20.copyWith(
                  letterSpacing: -0.30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
        ),
        Positioned(
          child: SlidingProduct(
            slidingAnimation: slidingAnimation,
            productImage: widget.product!.imagePath,
          ),
        ),
      ],
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
