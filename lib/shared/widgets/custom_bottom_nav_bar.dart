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
// S — Single Responsibility: Custom painter rendering the authentic 3D chiclet
//     active button geometry with pixel-perfect perspective, 3D bottom-right
//     extrusion, specular edge highlight, and ambient glow.
// ─────────────────────────────────────────────────────────────────────────────

class ActiveTabButtonPainter extends CustomPainter {
  /// Vertical slant offset across the button width (tan(11.31°) ≈ 0.20).
  final double skewDy;

  /// 3D extrusion depth along the bottom-right lighting angle.
  final double depth;

  /// Smooth vertex corner radius.
  final double cornerRadius;

  const ActiveTabButtonPainter({
    required this.skewDy,
    required this.depth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height - depth;
    final double r = cornerRadius;

    // 1. Build the base rounded rectangle for the front face
    final baseRect = Rect.fromLTWH(0, 0, w, h);
    final rawRRect = RRect.fromRectAndRadius(baseRect, Radius.circular(r));
    final rawPath = Path()..addRRect(rawRRect);

    // 2. Skew along Y by -0.20 and translate Y by skewDy:
    //    Top edge rises by skewDy from left to right; vertical sides remain 100% vertical.
    final matrix = Matrix4.identity()
      ..setTranslationRaw(0.0, skewDy, 0.0)
      ..setEntry(1, 0, -skewDy / w);

    final facePath = rawPath.transform(matrix.storage);

    // Light source comes from top-left, projecting 3D extrusion towards bottom-right
    final extrusionOffset = Offset(1.0, depth);
    final basePath = facePath.shift(extrusionOffset);

    // 3. Soft ambient drop shadow underneath the 3D base
    final shadowPaint = Paint()
      ..color = const Color(0xFF0C142B).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
    canvas.drawPath(basePath.shift(const Offset(0.5, 3.0)), shadowPaint);

    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(basePath.shift(const Offset(0.0, 2.0)), glowPaint);

    // 4. Solid 3D extrusion base and sides
    final extrusionPath = Path.combine(PathOperation.union, facePath, basePath);
    final extrusionPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3850B5), // Deep periwinkle transition
          Color(0xFF222C72), // Rich navy indigo base shadow
        ],
      ).createShader(extrusionPath.getBounds());
    canvas.drawPath(extrusionPath, extrusionPaint);

    // 5. Front face with signature vibrant cyan-to-royal-indigo gradient
    final facePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.8, -0.8),
        end: Alignment(0.9, 0.9),
        colors: [
          Color(0xFF5AB6EB), // Sky cyan highlight
          Color(0xFF4C87E8), // Radiant cyan-blue midtone
          Color(0xFF485EE6), // Electric royal indigo
        ],
      ).createShader(facePath.getBounds());
    canvas.drawPath(facePath, facePaint);

    // 6. Specular edge shine along the top and left bevel
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.45, 1.0],
        colors: [
          Color(0xCCB3E5FC), // Specular light reflection on top-left
          Color(0x3537B6E9), // Ambient blue sheen
          Color(0x004B4CED), // Transparent fade towards bottom-right
        ],
      ).createShader(facePath.getBounds());
    canvas.drawPath(facePath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant ActiveTabButtonPainter oldDelegate) {
    return oldDelegate.skewDy != skewDy ||
        oldDelegate.depth != depth ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: Renders the active button containing the unskewed,
//     crisp SVG icon centered inside the custom painted 3D chiclet geometry.
// I — Interface Segregation: Only requires the icon asset path and tap callback.
// ─────────────────────────────────────────────────────────────────────────────

class _ActiveTabButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _ActiveTabButton({required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = 56.w;
    final double buttonHeight = 50.h;
    final double depth = 4.2.h;
    final double cornerRadius = 8.5.r;
    final double iconSize = 24.r;
    final double skewDy = buttonWidth * 0.20;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Transform.translate(
          // Floats gracefully above the navigation bar baseline to match the design
          offset: Offset(0, -8.h),
          child: SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Custom painted 3D chiclet geometry
                Positioned.fill(
                  child: CustomPaint(
                    painter: ActiveTabButtonPainter(
                      skewDy: skewDy,
                      depth: depth,
                      cornerRadius: cornerRadius,
                    ),
                  ),
                ),

                // Pure, unskewed, upright, crisp white SVG icon centered in the face
                Transform.translate(
                  offset: Offset(0, 1.5.h),
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
              ],
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
  static const Color _kInactiveColor = Colors.grey;

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
              colorFilter: const ColorFilter.mode(
                _kInactiveColor,
                BlendMode.srcIn,
              ),
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
/// - Active elevated state featuring a custom painted 3D chiclet button
///   with pixel-perfect perspective, 3D bottom bevel depth, and specular sheen.
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
