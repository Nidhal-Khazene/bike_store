import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class ProductDetailsViewBody extends StatelessWidget {
  final ProductItem? product;

  const ProductDetailsViewBody({super.key, this.product});

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
      ],
    );
  }
}
