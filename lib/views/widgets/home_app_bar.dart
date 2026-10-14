import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Choose Your Bike',
          style: AppTextStyles.bold20.copyWith(color: Colors.white),
        ),
        CustomIconContainer(
          icon: SvgPicture.asset(Assets.assetsImagesIconsSearchIcon),
        ),
      ],
    );
  }
}
