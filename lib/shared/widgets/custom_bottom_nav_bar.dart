import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Immutable data model for navigation items.
// O — Open/Closed: Extensible with custom ids, labels, or icon paths.
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a single item displayed in the [CustomBottomNavBar].
class CustomBottomNavItem {
  /// Unique identifier for this item (e.g. 'bicycle', 'map', 'cart').
  final String id;

  /// Asset path to the SVG icon.
  final String iconPath;

  /// Optional accessibility / semantic label.
  final String? label;

  const CustomBottomNavItem({
    required this.id,
    required this.iconPath,
    this.label,
  });

  /// The standard 5 navigation items matching the authentic Bike Store design:
  /// 1. Bicycle (Home / Bikes catalog)
  /// 2. Map (Store / Route navigation)
  /// 3. Cart (Shopping cart)
  /// 4. Person (User profile)
  /// 5. Document (Receipts / Orders history)
  static const List<CustomBottomNavItem> defaultItems = [
    CustomBottomNavItem(
      id: 'bicycle',
      iconPath: Assets.assetsImagesIconsBicycleIcon,
      label: 'Bicycle',
    ),
    CustomBottomNavItem(
      id: 'map',
      iconPath: Assets.assetsImagesIconsMapFillIcon,
      label: 'Map',
    ),
    CustomBottomNavItem(
      id: 'cart',
      iconPath: Assets.assetsImagesIconsCartFillIcon,
      label: 'Cart',
    ),
    CustomBottomNavItem(
      id: 'profile',
      iconPath: Assets.assetsImagesIconsPersonFillIcon,
      label: 'Profile',
    ),
    CustomBottomNavItem(
      id: 'receipt',
      iconPath: Assets.assetsImagesIconsDocTextFillIcon,
      label: 'Receipt',
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Renders the authentic slanted navy background image.
// ─────────────────────────────────────────────────────────────────────────────

class _NavBarBackground extends StatelessWidget {
  final double height;

  const _NavBarBackground({required this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height,
      child: Image.asset(
        Assets.assetsImagesComponentBottomNavBarBg,
        fit: BoxFit.fill,
        width: double.infinity,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Renders the active elevated, skewed 3D gradient button.
// I — Interface Segregation: Only requires the icon path and tap callback.
// ─────────────────────────────────────────────────────────────────────────────

class _ActiveTabButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  /// Vertical skew angle matching the geometric slant in the design screenshot (~ -9.1°).
  static const double _kSkewY = -0.16;

  /// Counter-skew applied to the inner SVG icon to maintain an upright, crisp silhouette.
  static const double _kIconCounterSkewY = 0.12;

  const _ActiveTabButton({required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = 52.w;
    final double buttonHeight = 44.h;
    final double borderRadius = 14.r;
    final double iconSize = 22.r;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Transform.translate(
          // Slightly floats above the nav bar baseline to match the design
          offset: Offset(0, -6.h),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.skewY(_kSkewY),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  // Crisp 3D bottom bevel / extruded edge matching the design's tactile depth
                  BoxShadow(
                    color: const Color(0xFF1B2A6B),
                    offset: Offset(0, 4.h),
                    blurRadius: 0,
                    spreadRadius: 0.5,
                  ),
                  // Soft primary blue glow
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    offset: Offset(0, 6.h),
                    blurRadius: 10.r,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.skewY(_kIconCounterSkewY),
                  child: SvgPicture.asset(
                    iconPath,
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Renders an unselected, subtly tinted SVG icon tab.
// ─────────────────────────────────────────────────────────────────────────────

class _InactiveTabButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  /// Soft light silver-blue icon tone matching the design sample (#ABB3C6 / #8E95A8).
  static Color _kInactiveColor = Colors.grey.shade100;

  const _InactiveTabButton({required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double iconSize = 18.r;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: SizedBox(
          width: 52.w,
          height: 44.h,
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(_kInactiveColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Renders the sleek iOS home indicator pill at the bottom.
// ─────────────────────────────────────────────────────────────────────────────

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 8.h,
      child: Center(
        child: Container(
          width: 135.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Orchestrates the bottom navigation bar UI & interaction.
// O — Open/Closed: Accepts custom items, custom selectedIndex, and callbacks.
// D — Dependency Inversion: Driven by [CustomBottomNavItem] models.
// ─────────────────────────────────────────────────────────────────────────────

/// A pixel-perfect reproduction of the Bike Store bottom navigation bar.
///
/// Features:
/// - Asymmetrical slanted dark navy backdrop with rounded bottom geometry.
/// - Five dedicated navigation tabs with authentic SVG icons.
/// - Active elevated state featuring a skewed gradient pill container with 3D tactile depth.
/// - Clean iOS home indicator pill bar centered at the bottom.
/// - Full support for both controlled (`selectedIndex` + `onItemSelected`)
///   and uncontrolled (internal state management) patterns.
class CustomBottomNavBar extends StatefulWidget {
  /// The index of the currently active tab.
  /// If null, [CustomBottomNavBar] manages its own internal state.
  final int? selectedIndex;

  /// Callback fired whenever a navigation tab is tapped.
  final ValueChanged<int>? onItemSelected;

  /// The list of items to display. Defaults to [CustomBottomNavItem.defaultItems].
  final List<CustomBottomNavItem> items;

  /// Whether to display the white home indicator pill at the bottom.
  final bool showHomeIndicator;

  /// Total height of the navigation bar widget. Defaults to `102.h`.
  final double? height;

  const CustomBottomNavBar({
    super.key,
    this.selectedIndex,
    this.onItemSelected,
    this.items = CustomBottomNavItem.defaultItems,
    this.showHomeIndicator = true,
    this.height,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _internalIndex = 0;

  int get _effectiveIndex => widget.selectedIndex ?? _internalIndex;

  void _handleTap(int index) {
    if (widget.selectedIndex == null) {
      setState(() {
        _internalIndex = index;
      });
    }
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final double totalHeight = widget.height ?? 102.h;
    final double bgHeight = totalHeight - 4.h;

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Slanted dark navy background image
          _NavBarBackground(height: bgHeight),

          // 2. Navigation items row
          Positioned(
            left: 0,
            right: 0,
            bottom: 40.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < widget.items.length; i++)
                  Expanded(
                    child: i == _effectiveIndex
                        ? _ActiveTabButton(
                            iconPath: widget.items[i].iconPath,
                            onTap: () => _handleTap(i),
                          )
                        : _InactiveTabButton(
                            iconPath: widget.items[i].iconPath,
                            onTap: () => _handleTap(i),
                          ),
                  ),
              ],
            ),
          ),

          // 3. iOS Home indicator bar
          if (widget.showHomeIndicator) const _HomeIndicator(),
        ],
      ),
    );
  }
}
