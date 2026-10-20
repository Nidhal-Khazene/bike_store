import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

class MyShoppingCartViewBody extends StatelessWidget {
  const MyShoppingCartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomIconContainer(
              onTap: () => Navigator.pop(context),
              icon: SvgPicture.asset(Assets.assetsImagesIconsArowwLeftIcon),
            ),
            Text(
              'My Shopping Cart',
              style: AppTextStyles.bold20.copyWith(color: Colors.white),
            ),
            SizedBox(width: 44.w),
          ],
        ),
      ],
    );
  }
}
