import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: favorite heart button with optional neon cyan glow.
// ─────────────────────────────────────────────────────────────────────────────

class ProductFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final Color color;
  final bool hasGlow;
  final VoidCallback onTap;

  const ProductFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.color,
    required this.hasGlow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36.r,
        height: 36.r,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (hasGlow)
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightBlue.withValues(alpha: 0.45),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            SvgPicture.asset(
              Assets.assetsImagesIconsHeartIcon,
              width: 22.r,
              height: 22.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
