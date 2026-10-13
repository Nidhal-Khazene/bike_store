import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/bike_container_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BikePromotionCard extends StatelessWidget {
  const BikePromotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BikeContainerPresenter(
      child: Stack(
        children: [
          // Bike image — fills the card, slightly overflowing upward
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(42),
              child: Image.asset(Assets.assetsImagesComponentElectricBicycle),
            ),
          ),

          // "30% Off" label at the bottom-left
          Positioned(
            left: 20.w,
            bottom: 24.h,
            child: Text(
              '30% Off',
              style: AppTextStyles.bold26.copyWith(
                color: Colors.white.withValues(alpha: 0.60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
