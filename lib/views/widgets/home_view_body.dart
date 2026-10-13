import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:bike_store/views/widgets/bike_categories.dart';
import 'package:bike_store/views/widgets/bike_promotion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';

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
          top: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 72.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose Your Bike',
                        style: AppTextStyles.bold20.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      CustomIconContainer(
                        icon: SvgPicture.asset(
                          Assets.assetsImagesIconsSearchIcon,
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),
                  const BikePromotionCard(),
                  const BikeCategories(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
