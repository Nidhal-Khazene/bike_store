import 'dart:math' as math;
import 'package:bike_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A custom container that reproduces the slanted, sleek dark-blue glassmorphic
/// banner card from the Bike Store design.
///
/// Features:
/// - Rounded rectangular geometry with a dynamically slanted bottom edge.
/// - Rich multi-stop gradient (deep slate navy to ambient ocean cyan glow).
/// - Glassmorphism gradient border stroke.
/// - Soft multi-layer path-accurate ambient and directional shadows.
/// - Optional [child] clipped to the exact presenter geometry via [BikeContainerPresenterClipper].
class BikeContainerPresenter extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget? child;

  /// Width of the container. If null, stretches to fit parent constraints.
  final double? width;

  /// Total height of the container (at its tallest left edge).
  /// Defaults to `215.h` (or 215.0 if ScreenUtil is not initialized).
  final double? height;

  /// Vertical height of the slant on the bottom edge.
  /// The right side is raised by this amount compared to the left side.
  /// Defaults to `32.h`.
  final double? slantHeight;

  /// Corner radius for all 4 smoothed vertices.
  /// Defaults to `26.r`.
  final double? borderRadius;

  /// Inner background gradient. Defaults to the dark slate-to-steel-cyan gradient.
  final Gradient? gradient;

  /// Gradient applied to the outer stroke border.
  final Gradient? borderGradient;

  /// Thickness of the outer border outline. Defaults to `1.2`.
  final double borderWidth;

  /// Whether to render the soft elevation shadow around the container.
  final bool showShadow;

  /// Shadow color override.
  final Color? shadowColor;

  /// Optional padding applied around the [child].
  final EdgeInsetsGeometry? padding;

  /// Optional alignment of the [child].
  final AlignmentGeometry? alignment;

  /// Optional callback when tapped.
  final VoidCallback? onTap;

  const BikeContainerPresenter({
    super.key,
    this.child,
    this.width,
    this.height,
    this.slantHeight,
    this.borderRadius,
    this.gradient,
    this.borderGradient,
    this.borderWidth = 1.2,
    this.showShadow = true,
    this.shadowColor,
    this.padding,
    this.alignment,
    this.onTap,
  });

  /// The authentic surface gradient matching the bike store presenter asset:
  /// deep slate navy on the top-left to radiant ocean cyan glow on the right.
  static const LinearGradient defaultCardGradient = LinearGradient(
    begin: Alignment(-0.95, -0.85),
    end: Alignment(1.0, 0.75),
    stops: [0.0, 0.45, 1.0],
    colors: [
      AppColors.cardColor,      // ✅ #353F54 — delta 19 vs sampled #2E384B
      AppColors.background,     // ✅ #242C3B — delta 12 vs sampled #262F3F
      Color(0xFF2E577D),        // ❌ Ocean-cyan sheen — delta 48, no AppColors match
    ],
  );

  /// Authentic bevel border gradient:
  /// soft slate highlight on top-left to vibrant cyan-blue reflection on bottom-right.
  static const LinearGradient defaultBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.4, 1.0],
    colors: [
      Color(0x805C6882), // Soft white-slate specular highlight
      Color(0x33445068), // Subtle mid border
      Color(0xCC39729E), // Ambient light-blue reflection
    ],
  );

  @override
  Widget build(BuildContext context) {
    final double effectiveHeight = height ?? 215.h;
    final double effectiveSlant = slantHeight ?? 32.h;
    final double effectiveRadius = borderRadius ?? 26.r;
    final Gradient effectiveGradient = gradient ?? defaultCardGradient;
    final Gradient effectiveBorderGradient =
        borderGradient ?? defaultBorderGradient;

    final Widget containerBody = SizedBox(
      width: width ?? double.infinity,
      height: effectiveHeight,
      child: CustomPaint(
        painter: BikeContainerPainter(
          slantHeight: effectiveSlant,
          borderRadius: effectiveRadius,
          gradient: effectiveGradient,
          borderGradient: effectiveBorderGradient,
          borderWidth: borderWidth,
          showShadow: showShadow,
          shadowColor: shadowColor,
        ),
        child: ClipPath(
          clipper: BikeContainerPresenterClipper(
            slantHeight: effectiveSlant,
            borderRadius: effectiveRadius,
          ),
          child: Container(
            padding: padding,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: containerBody,
      );
    }

    return containerBody;
  }
}

/// Computes the exact smooth polygon path with 4 rounded corners
/// and an upward-slanted bottom edge.
Path createBikeContainerPath({
  required Size size,
  required double slantHeight,
  required double borderRadius,
}) {
  final double w = size.width;
  final double h = size.height;

  // Clamp radius and slant safely within size constraints
  final double safeSlant = slantHeight.clamp(0.0, h * 0.5);
  final double maxRadius = math.min(w / 2, (h - safeSlant) / 2);
  final double r = borderRadius.clamp(0.0, math.max(0.0, maxRadius));

  final Path path = Path();

  if (r == 0) {
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    path.lineTo(w, h - safeSlant);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  // 1. Top-Left Corner (90 deg)
  path.moveTo(0, r);
  path.quadraticBezierTo(0, 0, r, 0);

  // 2. Top Edge to Top-Right Corner (90 deg)
  path.lineTo(w - r, 0);
  path.quadraticBezierTo(w, 0, w, r);

  // Bottom edge vector & geometry:
  // Vertex 2 (Bottom-Right) = (w, h - safeSlant)
  // Vertex 3 (Bottom-Left) = (0, h)
  final Offset v2 = Offset(w, h - safeSlant);
  final Offset v3 = Offset(0, h);

  final Offset bottomVec = v3 - v2;
  final double bottomLen = bottomVec.distance;
  final Offset bottomUnit =
      bottomLen > 0 ? (bottomVec / bottomLen) : const Offset(-1, 0);

  // 3. Right Edge down to Bottom-Right Corner:
  // Tangent point entering corner from vertical right edge:
  final Offset t2In = Offset(w, (h - safeSlant) - r);
  // Tangent point exiting corner onto slanted bottom edge:
  final Offset t2Out = v2 + bottomUnit * r;

  path.lineTo(t2In.dx, t2In.dy);
  path.quadraticBezierTo(v2.dx, v2.dy, t2Out.dx, t2Out.dy);

  // 4. Slanted Bottom Edge towards Bottom-Left Corner:
  // Tangent point entering corner from slanted bottom edge:
  final Offset t3In = v3 - bottomUnit * r;
  // Tangent point exiting corner onto vertical left edge:
  final Offset t3Out = Offset(0, h - r);

  path.lineTo(t3In.dx, t3In.dy);
  path.quadraticBezierTo(v3.dx, v3.dy, t3Out.dx, t3Out.dy);

  path.close();
  return path;
}

/// Custom clipper that clips any child to the shape of the [BikeContainerPresenter].
class BikeContainerPresenterClipper extends CustomClipper<Path> {
  final double slantHeight;
  final double borderRadius;

  const BikeContainerPresenterClipper({
    required this.slantHeight,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    return createBikeContainerPath(
      size: size,
      slantHeight: slantHeight,
      borderRadius: borderRadius,
    );
  }

  @override
  bool shouldReclip(covariant BikeContainerPresenterClipper oldClipper) {
    return oldClipper.slantHeight != slantHeight ||
        oldClipper.borderRadius != borderRadius;
  }
}

/// Custom painter that renders:
/// 1. Accurate soft drop shadows conforming to the custom polygon shape.
/// 2. Anti-aliased gradient fill.
/// 3. Glassmorphic gradient border outline.
class BikeContainerPainter extends CustomPainter {
  final double slantHeight;
  final double borderRadius;
  final Gradient gradient;
  final Gradient borderGradient;
  final double borderWidth;
  final bool showShadow;
  final Color? shadowColor;

  const BikeContainerPainter({
    required this.slantHeight,
    required this.borderRadius,
    required this.gradient,
    required this.borderGradient,
    required this.borderWidth,
    required this.showShadow,
    this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Path path = createBikeContainerPath(
      size: size,
      slantHeight: slantHeight,
      borderRadius: borderRadius,
    );

    // 1. Soft Path Shadows
    if (showShadow) {
      final Color baseShadow = shadowColor ?? const Color(0xFF000000);

      // Ambient blur spread shadow
      final Paint ambientShadowPaint = Paint()
        ..color = baseShadow.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
      canvas.save();
      canvas.translate(0, 10);
      canvas.drawPath(path, ambientShadowPaint);
      canvas.restore();

      // Deeper directional shadow
      final Paint directShadowPaint = Paint()
        ..color = baseShadow.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
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
  bool shouldRepaint(covariant BikeContainerPainter oldDelegate) {
    return oldDelegate.slantHeight != slantHeight ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.gradient != gradient ||
        oldDelegate.borderGradient != borderGradient ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.showShadow != showShadow ||
        oldDelegate.shadowColor != shadowColor;
  }
}
