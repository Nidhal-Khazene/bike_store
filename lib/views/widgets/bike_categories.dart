import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: pure data model representing a category item.
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a single bike category item.
class BikeCategory {
  final String id;
  final String? label;
  final String? iconPath;

  const BikeCategory({required this.id, this.label, this.iconPath})
    : assert(
        label != null || iconPath != null,
        'A BikeCategory must have at least a label or an iconPath.',
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: renders the "All" text label.
// ─────────────────────────────────────────────────────────────────────────────

class _AllLabel extends StatelessWidget {
  const _AllLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      'All',
      style: AppTextStyles.medium13.copyWith(color: Colors.white),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: renders a tinted SVG icon.
// I — Interface Segregation: only exposes path, size, and color.
// ─────────────────────────────────────────────────────────────────────────────

/// Renders an SVG asset tinted with [color].
class _CategoryIcon extends StatelessWidget {
  final String path;
  final Color color;
  final double size;

  const _CategoryIcon({
    required this.path,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: renders ONE category chip container.
// O — Open/Closed: styling is driven by design tokens; extendable via model.
// L — Liskov: _AllLabel and _CategoryIcon are substitutable Widget children.
// ─────────────────────────────────────────────────────────────────────────────

/// Renders a single category chip based on [BikeCategory]:
/// • "All" pill → primary gradient [CustomIconContainer] with white text
/// • Icon items → dark slate-navy gradient [CustomIconContainer] matching new design
class _CategoryItemWidget extends StatelessWidget {
  final BikeCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _size = 50.0;
  static const double _radius = 10.0;
  static const double _iconSize = 24.0;

  /// Soft light silver-blue tone matching the new design icon color (#ABB3C6).
  static const Color _iconColor = Color(0xFFABB3C6);

  /// Dark card gradient matching the clean dark navy surface in the new design.
  static const LinearGradient _cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.cardColor, // Color(0xFF353F54)
      AppColors.deepNavy, // Color(0xFF222834)
    ],
  );

  const _CategoryItemWidget({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAllPill = category.label != null;

    if (isAllPill) {
      // "All" pill → primary gradient container.
      return CustomIconContainer(
        onTap: onTap,
        size: _size.r,
        borderRadius: BorderRadius.circular(_radius.r),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        icon: const _AllLabel(),
      );
    }

    // Icon tile → clean dark navy container matching the new design.
    return CustomIconContainer(
      onTap: onTap,
      size: _size.r,
      borderRadius: BorderRadius.circular(_radius.r),
      gradient: _cardGradient,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      icon: _CategoryIcon(
        path: category.iconPath!,
        color: _iconColor,
        size: _iconSize.r,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: owns category list, selection state & staircase layout.
// D — Dependency Inversion: depends on [BikeCategory] model, not hardcoded widgets.
// ─────────────────────────────────────────────────────────────────────────────

/// Horizontally scrollable category row with a staircase visual effect.
class BikeCategories extends StatefulWidget {
  /// Notified whenever the active category changes.
  final ValueChanged<BikeCategory>? onCategorySelected;

  const BikeCategories({super.key, this.onCategorySelected});

  @override
  State<BikeCategories> createState() => _BikeCategoriesState();
}

class _BikeCategoriesState extends State<BikeCategories> {
  // ── I — Interface Segregation: state only knows the model list. ─────────────
  static const List<BikeCategory> _categories = [
    BikeCategory(id: 'all', label: 'All'),
    BikeCategory(id: 'bicycle', iconPath: Assets.assetsImagesIconsBicycleIcon),
    BikeCategory(id: 'road', iconPath: Assets.assetsImagesIconsRoadIcon),
    BikeCategory(
      id: 'mountain',
      iconPath: Assets.assetsImagesIconsMountainIcon,
    ),
    BikeCategory(id: 'helmet', iconPath: Assets.assetsImagesIconsBikeHatIcon),
  ];

  /// Vertical upward shift applied to each successive chip (staircase).
  static const double _stepDy = 10.0;

  String _selectedId = 'all';

  void _onSelect(BikeCategory category) {
    if (_selectedId == category.id) return;
    setState(() => _selectedId = category.id);
    widget.onCategorySelected?.call(category);
  }

  @override
  Widget build(BuildContext context) {
    final double chipSize = _CategoryItemWidget._size.r;
    final double totalHeight = chipSize + (_categories.length - 1) * _stepDy;

    return SizedBox(
      height: totalHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < _categories.length; i++) ...[
              // Each chip is shifted upward by i × _stepDy (staircase).
              Transform.translate(
                offset: Offset(0, -(i * _stepDy)),
                child: _CategoryItemWidget(
                  category: _categories[i],
                  isSelected: _selectedId == _categories[i].id,
                  onTap: () => _onSelect(_categories[i]),
                ),
              ),
              if (i < _categories.length - 1) Gap(12.w),
            ],
          ],
        ),
      ),
    );
  }
}
