import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/views/widgets/my_shopping_cart_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyShoppingCartView extends StatelessWidget {
  const MyShoppingCartView({super.key});
  static const routeName = "MyShoppingCartView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const MyShoppingCartViewBody(),
        ),
      ),
    );
  }
}
