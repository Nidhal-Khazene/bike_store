import 'package:bike_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final double? size;
  final Widget icon;
  final Gradient? gradient;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Color? iconColor;
  final double? iconSize;

  const CustomIconContainer({
    super.key,
    this.onTap,
    this.size,
    required this.icon,
    this.gradient,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveSize = size ?? 44.r;
    final bool hasExplicitColor = color != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          color: color,
          gradient: hasExplicitColor
              ? null
              : (gradient ?? AppColors.primaryGradient),
          borderRadius:
              borderRadius ?? BorderRadius.circular(effectiveSize * 0.28),
          border: border,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              size: iconSize ?? (effectiveSize * 0.48),
              color: iconColor ?? Colors.white,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
