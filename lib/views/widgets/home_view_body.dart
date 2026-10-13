import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';

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
      ],
    );
  }
}
