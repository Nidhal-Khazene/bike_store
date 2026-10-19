import 'package:flutter/material.dart';

class SlidingProduct extends StatelessWidget {
  const SlidingProduct({
    super.key,
    required this.slidingAnimation,
    required this.productImage,
  });

  final Animation<Offset> slidingAnimation;
  final String productImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) => SlideTransition(
        position: slidingAnimation,
        child: Center(child: Image.asset(productImage)),
      ),
    );
  }
}
