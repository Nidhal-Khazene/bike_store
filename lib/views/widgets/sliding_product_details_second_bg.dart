import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';

class SlidingProductDetailsSecondBg extends StatelessWidget {
  const SlidingProductDetailsSecondBg({
    super.key,
    required this.slidingAnimation,
  });

  final Animation<Offset> slidingAnimation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) => SlideTransition(
        position: slidingAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Image.asset(
            Assets.assetsImagesComponentBlueBg,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
