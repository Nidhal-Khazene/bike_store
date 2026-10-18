import 'dart:math' as math;
import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: pure data model representing a product item.
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a single product in the store catalog.
class ProductItem {
  final String id;
  final String name;
  final String category;
  final String price;
  final String imagePath;
  final bool isActive;
  final bool isFavorite;

  const ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    this.isActive = false,
    this.isFavorite = false,
  });

  ProductItem copyWith({
    String? id,
    String? name,
    String? category,
    String? price,
    String? imagePath,
    bool? isActive,
    bool? isFavorite,
  }) {
    return ProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// O — Open/Closed: card style tokens encapsulate active & inactive variants.
// ─────────────────────────────────────────────────────────────────────────────

/// Encapsulates all visual styling tokens for a slanted product card.
class ProductCardStyle {
  /// The gradient used to fill the card surface.
  final Gradient gradient;

  /// The gradient used for the outer glassmorphic specular stroke.
  final Gradient borderGradient;

  /// The width of the outer stroke border.
  final double borderWidth;

  /// Ambient and directional shadow colors.
  final Color shadowColor;

  /// The color filter applied to the heart favorite icon.
  final Color heartColor;

  /// Whether the heart favorite icon emits an ambient cyan glow.
  final bool hasHeartGlow;

  const ProductCardStyle({
    required this.gradient,
    required this.borderGradient,
    this.borderWidth = 1.2,
    this.shadowColor = const Color(0xFF000000),
    required this.heartColor,
    this.hasHeartGlow = false,
  });

  /// Pixel-perfect Active element style:
  /// - Deep slate navy card gradient (cardColor #353F54 to deepNavy #222834).
  /// - Specular highlight glassmorphism border stroke.
  /// - Neon cyan/blue glowing heart icon (#37B6E9).
  factory ProductCardStyle.active() {
    return const ProductCardStyle(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
        colors: [
          AppColors.cardColor, // #353F54
          Color(0xFF2C3446),
          AppColors.deepNavy, // #222834
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.45, 1.0],
        colors: [
          Color(0x995C6882), // Specular highlight on top-left edge
          Color(0x33445068), // Mid tone transition
          Color(0x1A222834), // Soft deep navy on bottom-right
        ],
      ),
      borderWidth: 1.2,
      shadowColor: Color(0xFF000000),
      heartColor: AppColors.lightBlue, // #37B6E9
      hasHeartGlow: true,
    );
  }

  /// Pixel-perfect Inactive element style:
  /// - Ocean-blue slate card surface matching sampled design (#3B5E88 to #274271).
  /// - Electric cyan-blue specular top-border highlight (#4B8BE3).
  /// - Crisp white heart outline.
  factory ProductCardStyle.inactive() {
    return const ProductCardStyle(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
        colors: [
          Color(0xFF3B5E88), // Light ocean-slate blue
          Color(0xFF304D79), // Mid ocean blue
          Color(0xFF274271), // Deep ocean navy
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.45, 1.0],
        colors: [
          Color(0xFF4B8BE3), // Vibrant electric cyan-blue highlight on top-left
          Color(0x4D35557E), // Subtle ocean stroke mid
          Color(0x26253F64), // Softer darker base stroke
        ],
      ),
      borderWidth: 1.2,
      shadowColor: Color(0xFF000000),
      heartColor: Colors.white,
      hasHeartGlow: false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GEOMETRY — Smooth oblique rounded parallelogram math.
// ─────────────────────────────────────────────────────────────────────────────

/// Computes the exact smooth polygon path with 4 rounded corners and
/// parallel upward-slanted top and bottom edges.
Path createSlantedCardPath({
  required Size size,
  required double slantHeight,
  required double borderRadius,
}) {
  final double w = size.width;
  final double h = size.height;

  // Safe clamping
  final double safeSlant = slantHeight.clamp(0.0, h * 0.4);
  final double maxRadius = math.min(w / 2, (h - safeSlant) / 2);
  final double r = borderRadius.clamp(0.0, math.max(0.0, maxRadius));

  final Path path = Path();
  if (r == 0) {
    path.moveTo(0, safeSlant);
    path.lineTo(w, 0);
    path.lineTo(w, h - safeSlant);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  // Slanted edge vector from (0, safeSlant) to (w, 0)
  final double topLen = math.sqrt(w * w + safeSlant * safeSlant);
  final double ux = topLen > 0 ? (w / topLen) : 1.0;
  final double uy = topLen > 0 ? (-safeSlant / topLen) : 0.0;

  // Tangent points for 4 rounded vertices:
  // V0 = (0, safeSlant) [Top-Left]
  final Offset t0In = Offset(0, safeSlant + r);
  final Offset t0Out = Offset(ux * r, safeSlant + uy * r);

  // V1 = (w, 0) [Top-Right]
  final Offset t1In = Offset(w - ux * r, -uy * r);
  final Offset t1Out = Offset(w, r);

  // V2 = (w, h - safeSlant) [Bottom-Right]
  final Offset t2In = Offset(w, h - safeSlant - r);
  final Offset t2Out = Offset(w - ux * r, h - safeSlant - uy * r);

  // V3 = (0, h) [Bottom-Left]
  final Offset t3In = Offset(ux * r, h + uy * r);
  final Offset t3Out = Offset(0, h - r);

  // 1. Move to Top-Left curve exit
  path.moveTo(t0Out.dx, t0Out.dy);

  // 2. Top Slanted Edge to Top-Right Corner
  path.lineTo(t1In.dx, t1In.dy);
  path.quadraticBezierTo(w, 0, t1Out.dx, t1Out.dy);

  // 3. Right Vertical Edge to Bottom-Right Corner
  path.lineTo(t2In.dx, t2In.dy);
  path.quadraticBezierTo(w, h - safeSlant, t2Out.dx, t2Out.dy);

  // 4. Bottom Slanted Edge to Bottom-Left Corner
  path.lineTo(t3In.dx, t3In.dy);
  path.quadraticBezierTo(0, h, t3Out.dx, t3Out.dy);

  // 5. Left Vertical Edge to Top-Left Corner
  path.lineTo(t0In.dx, t0In.dy);
  path.quadraticBezierTo(0, safeSlant, t0Out.dx, t0Out.dy);

  path.close();
  return path;
}

// ─────────────────────────────────────────────────────────────────────────────
// L — Liskov Substitution: custom clipper matching the custom painter geometry.
// ─────────────────────────────────────────────────────────────────────────────

/// Custom clipper that clips any child content to the slanted card geometry.
class SlantedCardClipper extends CustomClipper<Path> {
  final double slantHeight;
  final double borderRadius;

  const SlantedCardClipper({
    required this.slantHeight,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    return createSlantedCardPath(
      size: size,
      slantHeight: slantHeight,
      borderRadius: borderRadius,
    );
  }

  @override
  bool shouldReclip(covariant SlantedCardClipper oldClipper) {
    return oldClipper.slantHeight != slantHeight ||
        oldClipper.borderRadius != borderRadius;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: custom painter for slanted background & glass stroke.
// ─────────────────────────────────────────────────────────────────────────────

/// Paints the pixel-perfect slanted card background with path-accurate shadows,
/// gradient fill, and glassmorphic specular stroke border.
class SlantedCardPainter extends CustomPainter {
  final double slantHeight;
  final double borderRadius;
  final Gradient gradient;
  final Gradient borderGradient;
  final double borderWidth;
  final bool showShadow;
  final Color shadowColor;

  const SlantedCardPainter({
    required this.slantHeight,
    required this.borderRadius,
    required this.gradient,
    required this.borderGradient,
    this.borderWidth = 1.2,
    this.showShadow = true,
    this.shadowColor = const Color(0xFF000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Path path = createSlantedCardPath(
      size: size,
      slantHeight: slantHeight,
      borderRadius: borderRadius,
    );

    // 1. Soft Path Shadows
    if (showShadow) {
      // Ambient blur spread shadow
      final Paint ambientShadowPaint = Paint()
        ..color = shadowColor.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.save();
      canvas.translate(0, 10);
      canvas.drawPath(path, ambientShadowPaint);
      canvas.restore();

      // Deeper directional shadow
      final Paint directShadowPaint = Paint()
        ..color = shadowColor.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.save();
      canvas.translate(0, 4);
      canvas.drawPath(path, directShadowPaint);
      canvas.restore();
    }

    // 2. Interior Fill
    final Paint fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Outer Glassmorphism Stroke Border
    if (borderWidth > 0) {
      final Paint borderPaint = Paint()
        ..shader = borderGradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SlantedCardPainter oldDelegate) {
    return oldDelegate.slantHeight != slantHeight ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.gradient != gradient ||
        oldDelegate.borderGradient != borderGradient ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.showShadow != showShadow ||
        oldDelegate.shadowColor != shadowColor;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: favorite heart button with optional neon cyan glow.
// ─────────────────────────────────────────────────────────────────────────────

class _ProductFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final Color color;
  final bool hasGlow;
  final VoidCallback onTap;

  const _ProductFavoriteButton({
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

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: renders a single slanted product card.
// ─────────────────────────────────────────────────────────────────────────────

class _ProductCardWidget extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const _ProductCardWidget({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
  });

  static const double _cardHeight = 220.0;
  static const double _slantHeight = 18.0;
  static const double _borderRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    final double effectiveHeight = _cardHeight.h;
    final double effectiveSlant = _slantHeight.h;
    final double effectiveRadius = _borderRadius.r;

    final ProductCardStyle style = product.isActive
        ? ProductCardStyle.active()
        : ProductCardStyle.inactive();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        height: effectiveHeight,
        child: CustomPaint(
          painter: SlantedCardPainter(
            slantHeight: effectiveSlant,
            borderRadius: effectiveRadius,
            gradient: style.gradient,
            borderGradient: style.borderGradient,
            borderWidth: style.borderWidth,
            shadowColor: style.shadowColor,
          ),
          child: ClipPath(
            clipper: SlantedCardClipper(
              slantHeight: effectiveSlant,
              borderRadius: effectiveRadius,
            ),
            child: Stack(
              children: [
                // 1. Favorite Heart Button (Top-Right)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: _ProductFavoriteButton(
                    isFavorite: product.isFavorite,
                    color: style.heartColor,
                    hasGlow: false,
                    onTap: onFavoriteTap,
                  ),
                ),

                // 2. Product Image (Upper center area)
                Positioned(
                  top: 26.h,
                  left: 14.w,
                  right: 14.w,
                  child: SizedBox(
                    height: 85.h,
                    child: Center(
                      child: Image.asset(
                        product.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // 3. Product Info (Bottom area)
                Positioned(
                  left: 16.w,
                  right: 12.w,
                  bottom: 22.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category / Subtitle
                      Text(
                        product.category,
                        style: AppTextStyles.medium13.copyWith(
                          color: const Color(0xFFABB3C6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(4),

                      // Name / Title
                      Text(
                        product.name,
                        style: AppTextStyles.bold15.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(6),

                      // Price
                      Text(
                        product.price,
                        style: AppTextStyles.medium13.copyWith(
                          color: const Color(0xFFABB3C6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
// S — Single Responsibility: owns product state & 2-column staggered layout.
// D — Dependency Inversion: depends on [ProductItem] list; supports external callbacks.
// ─────────────────────────────────────────────────────────────────────────────

/// Staggered products grid with pixel-perfect active and inactive slanted elements.
class ProductsGridView extends StatefulWidget {
  /// Optional initial product items. Defaults to the authentic bike store catalog.
  final List<ProductItem>? products;

  /// Optional callback when a product card is tapped.
  final ValueChanged<ProductItem>? onProductSelected;

  /// Optional callback when a favorite icon is toggled.
  final ValueChanged<ProductItem>? onFavoriteToggle;

  const ProductsGridView({
    super.key,
    this.products,
    this.onProductSelected,
    this.onFavoriteToggle,
  });

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  late List<ProductItem> _items;

  /// Authentic catalog matching the provided design:
  /// - Card 1 (Left): Peugeot LR01 road bike, Active state (slate navy card, blue glowing heart).
  /// - Card 2 (Right): Smith Trade road helmet, Inactive state (ocean blue card, white heart).
  /// - Cards 3 & 4: Pilot Trans and Specialized e-bike completing the catalog.
  static final List<ProductItem> _defaultProducts = [
    const ProductItem(
      id: 'peugeot_lr01',
      name: 'PEUGEOT - LR01',
      category: 'Road Bike',
      price: '\$ 1,999.99',
      imagePath: Assets.assetsImagesComponentRobertBicycle,
      isActive: true,
      isFavorite: true,
    ),
    const ProductItem(
      id: 'smith_trade',
      name: 'SMITH - Trade',
      category: 'Road Helmet',
      price: '\$ 120',
      imagePath: Assets.assetsImagesComponentBicycleHat,
      isActive: false,
      isFavorite: false,
    ),
    const ProductItem(
      id: 'pilot_trans',
      name: 'PILOT - Trans',
      category: 'Road Bike',
      price: '\$ 2,999.99',
      imagePath: Assets.assetsImagesComponentMikkelBechBicycle,
      isActive: false,
      isFavorite: false,
    ),
    const ProductItem(
      id: 'specialized_electric',
      name: 'SPECIALIZED',
      category: 'Electric Bike',
      price: '\$ 3,499.99',
      imagePath: Assets.assetsImagesComponentElectricBicycle,
      isActive: false,
      isFavorite: false,
    ),
    const ProductItem(
      id: 'peugeot_lr01',
      name: 'PEUGEOT - LR01',
      category: 'Road Bike',
      price: '\$ 1,999.99',
      imagePath: Assets.assetsImagesComponentRobertBicycle,
      isActive: false,
      isFavorite: false,
    ),
    const ProductItem(
      id: 'smith_trade',
      name: 'SMITH - Trade',
      category: 'Road Helmet',
      price: '\$ 120',
      imagePath: Assets.assetsImagesComponentBicycleHat,
      isActive: false,
      isFavorite: false,
    ),
    const ProductItem(
      id: 'smith_trade',
      name: 'SMITH - Trade',
      category: 'Road Helmet',
      price: '\$ 120',
      imagePath: Assets.assetsImagesComponentBicycleHat,
      isActive: false,
      isFavorite: false,
    ),
    const ProductItem(
      id: 'pilot_trans',
      name: 'PILOT - Trans',
      category: 'Road Bike',
      price: '\$ 2,999.99',
      imagePath: Assets.assetsImagesComponentMikkelBechBicycle,
      isActive: false,
      isFavorite: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _items = widget.products ?? List.of(_defaultProducts);
  }

  void _onProductTap(int index) {
    setState(() {
      final String tappedId = _items[index].id;
      _items = _items.map((item) {
        return item.copyWith(isActive: item.id == tappedId);
      }).toList();
    });
    widget.onProductSelected?.call(_items[index]);
  }

  void _onFavoriteTap(int index) {
    setState(() {
      final ProductItem current = _items[index];
      _items[index] = current.copyWith(isFavorite: !current.isFavorite);
    });
    widget.onFavoriteToggle?.call(_items[index]);
  }

  @override
  Widget build(BuildContext context) {
    // Separate items into two staggered columns:
    // Left column: even indices (0, 2, ...) -> starts with 28.h top stagger
    // Right column: odd indices (1, 3, ...) -> starts at 0 to tuck under staircase
    final List<Widget> leftColumnWidgets = [
      Gap(28.h), // Stagger offset for the left column
    ];
    final List<Widget> rightColumnWidgets = [
      Gap(0.h), // Starts immediately below staircase
    ];

    for (int i = 0; i < _items.length; i++) {
      final int index = i;
      final Widget card = _ProductCardWidget(
        product: _items[index],
        onTap: () => _onProductTap(index),
        onFavoriteTap: () => _onFavoriteTap(index),
      );

      if (i.isEven) {
        if (leftColumnWidgets.length > 1) {
          leftColumnWidgets.add(Gap(20.h));
        }
        leftColumnWidgets.add(card);
      } else {
        if (rightColumnWidgets.length > 1) {
          rightColumnWidgets.add(Gap(20.h));
        }
        rightColumnWidgets.add(card);
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: leftColumnWidgets,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: rightColumnWidgets,
            ),
          ),
        ],
      ),
    );
  }
}
