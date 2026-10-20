import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInnerShadowContainer extends StatelessWidget {
  const CustomInnerShadowContainer({
    super.key,
    required this.title,
    this.onTap,
    this.isSelected = false,
    required this.isExpanded,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF282C37);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 43.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            // Top-left dark inner shadow (creates depth/recess)
            BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 8,
              color: Colors.black.withValues(alpha: 0.8),
              inset: true,
            ),
            // Bottom-right subtle highlight (adds the 3D groove effect)
            BoxShadow(
              offset: const Offset(-2, -2),
              blurRadius: 6,
              color: Colors.white.withValues(alpha: 0.05),
              inset: true,
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular15.copyWith(
              color: isExpanded && isSelected
                  ? const Color(0xFF3CA4EB)
                  : Colors.white,
              letterSpacing: 0.35,
              fontWeight: isExpanded && isSelected
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
