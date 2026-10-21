import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: interactive slide-to-checkout swipe button.
// ─────────────────────────────────────────────────────────────────────────────

/// Interactive slider button that slides from left to right to confirm checkout.
/// Matches Screen 13/14 (thumb on left) to Screen 15 (thumb on right).
class SlideToCheckoutButton extends StatefulWidget {
  final VoidCallback? onCheckout;
  final bool isCompleted;
  final VoidCallback? onReset;

  const SlideToCheckoutButton({
    super.key,
    this.onCheckout,
    this.isCompleted = false,
    this.onReset,
  });

  @override
  State<SlideToCheckoutButton> createState() => _SlideToCheckoutButtonState();
}

class _SlideToCheckoutButtonState extends State<SlideToCheckoutButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragProgress = 0.0;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {
          _dragProgress = _controller.value;
        });
      });

    if (widget.isCompleted) {
      _dragProgress = 1.0;
      _controller.value = 1.0;
      _hasTriggered = true;
    }
  }

  @override
  void didUpdateWidget(covariant SlideToCheckoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _controller.animateTo(1.0, curve: Curves.easeOut);
        _hasTriggered = true;
      } else {
        _controller.animateTo(0.0, curve: Curves.easeOutCubic);
        _hasTriggered = false;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_hasTriggered) return;
    if (maxDrag <= 0) return;

    setState(() {
      _dragProgress = (_dragProgress + details.primaryDelta! / maxDrag).clamp(0.0, 1.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_hasTriggered) return;

    if (_dragProgress >= 0.70) {
      // Complete slide to the right
      _controller.animateTo(1.0, curve: Curves.easeOut).then((_) {
        _hasTriggered = true;
        widget.onCheckout?.call();
      });
    } else {
      // Snap back to left
      _controller.animateTo(0.0, curve: Curves.easeOutCubic);
    }
  }

  void _handleTapToSlide() {
    if (_hasTriggered) {
      // Reset if tapped when completed
      _controller.animateTo(0.0, curve: Curves.easeOutCubic).then((_) {
        _hasTriggered = false;
        widget.onReset?.call();
      });
      return;
    }

    _controller.animateTo(1.0, curve: Curves.easeOut).then((_) {
      _hasTriggered = true;
      widget.onCheckout?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double trackHeight = 54.h;
    final double thumbWidth = 54.w;
    final double thumbHeight = 46.h;
    final double padding = 4.r;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - thumbWidth - (padding * 2);
        final double thumbLeft = padding + (_dragProgress * maxDrag);

        return GestureDetector(
          onTap: _handleTapToSlide,
          onHorizontalDragUpdate: (details) =>
              _onHorizontalDragUpdate(details, maxDrag),
          onHorizontalDragEnd: _onHorizontalDragEnd,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: trackHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2430),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // "Checkout" centered label that fades out as the thumb slides over
                Center(
                  child: Opacity(
                    opacity: (1.0 - (_dragProgress * 1.8)).clamp(0.0, 1.0),
                    child: Text(
                      'Checkout',
                      style: AppTextStyles.medium15.copyWith(
                        color: const Color(0xFF8A94A6),
                      ),
                    ),
                  ),
                ),

                // Draggable Slider Thumb
                Positioned(
                  left: thumbLeft,
                  top: padding,
                  bottom: padding,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) =>
                        _onHorizontalDragUpdate(details, maxDrag),
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: thumbWidth,
                      height: thumbHeight,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightBlue.withValues(alpha: 0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.assetsImagesIconsArrowRightIcon,
                          width: 10.w,
                          height: 16.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
