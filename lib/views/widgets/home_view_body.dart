import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/views/widgets/product_categories.dart';
import 'package:bike_store/views/widgets/bike_promotion_card.dart';
import 'package:bike_store/views/widgets/home_app_bar.dart';
import 'package:bike_store/views/widgets/products_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gap/gap.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: MediaQuery.sizeOf(context).height * .2,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset(
            Assets.assetsImagesComponentBlueBg,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 64,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: const HomeAppBar(),
          ),
        ),
        Positioned(
          top: 64,
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 64.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BikePromotionCard(),
                  const BikeCategories(),
                  const ProductsGridView(),
                  Gap(70.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
