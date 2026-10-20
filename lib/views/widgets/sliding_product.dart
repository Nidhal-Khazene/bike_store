import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidingProduct extends StatelessWidget {
  const SlidingProduct({
    super.key,
    required this.slidingAnimation,
    required this.productImage,
    this.isExpanded = false,
  });

  final Animation<Offset> slidingAnimation;
  final String productImage;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) => SlideTransition(
        position: slidingAnimation,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: isExpanded ? Alignment(0, -0.50.h) : Alignment(0, -0.08.h),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isExpanded ? 250.w : 340.w,
            height: isExpanded ? 160.h : 230.h,
            child: Image.asset(productImage, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
