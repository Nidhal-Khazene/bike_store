import 'package:bike_store/core/utils/app_colors.dart';
import 'package:bike_store/core/utils/app_text_styles.dart';
import 'package:bike_store/shared/widgets/custom_inner_shadow_container.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProductDetailsCustomBottomSheet extends StatefulWidget {
  const ProductDetailsCustomBottomSheet({
    super.key,
    this.slidingAnimation,
    this.product,
    this.initialIndex,
    this.onTabChanged,
    this.isExpanded,
    this.onExpandedChanged,
    this.collapsedHeight,
    this.expandedHeight,
    this.onAddToCart,
  });

  final Animation<Offset>? slidingAnimation;
  final ProductItem? product;
  final int? initialIndex;
  final ValueChanged<int>? onTabChanged;
  final bool? isExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final double? collapsedHeight;
  final double? expandedHeight;
  final VoidCallback? onAddToCart;

  @override
  State<ProductDetailsCustomBottomSheet> createState() =>
      _ProductDetailsCustomBottomSheetState();
}

class _ProductDetailsCustomBottomSheetState
    extends State<ProductDetailsCustomBottomSheet> {
  int? _selectedIndex;
  bool _internalExpanded = false;

  bool get isExpanded => widget.isExpanded ?? _internalExpanded;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _internalExpanded = widget.isExpanded ?? false;
  }

  @override
  void didUpdateWidget(covariant ProductDetailsCustomBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
    if (widget.isExpanded != null &&
        widget.isExpanded != oldWidget.isExpanded) {
      _internalExpanded = widget.isExpanded!;
    }
  }

  void _handleTap(int index) {
    final bool wasExpanded = isExpanded;
    final bool isSameTab = _selectedIndex == index;

    setState(() {
      _selectedIndex = index;
    });
    widget.onTabChanged?.call(index);

    if (isSameTab) {
      _setExpanded(!wasExpanded);
    } else {
      _setExpanded(true);
    }
  }

  void _setExpanded(bool value) {
    setState(() {
      _internalExpanded = value;
    });
    widget.onExpandedChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double effectiveCollapsedHeight = widget.collapsedHeight ?? 110.h;
    final double effectiveExpandedHeight =
        widget.expandedHeight ?? (screenHeight * 0.55);

    final Widget sheet = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      height: isExpanded ? effectiveExpandedHeight : effectiveCollapsedHeight,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.06, -0.02),
          end: Alignment(0.51, 0.61),
          colors: [Color(0xFF353F54), Color(0xFF222834)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 40,
            offset: Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 33.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 44.w),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomInnerShadowContainer(
                        title: "Description",
                        isSelected: _selectedIndex == 0,
                        onTap: () => _handleTap(0),
                        isExpanded: isExpanded,
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Expanded(
                      child: CustomInnerShadowContainer(
                        title: "Specification",
                        isSelected: _selectedIndex == 1,
                        onTap: () => _handleTap(1),
                        isExpanded: isExpanded,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16.h),
              if (isExpanded)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxHeight < 150.h) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: _buildTabContent(),
                            ),
                          ),
                          _buildBottomActionBar(context),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.slidingAnimation != null) {
      return AnimatedBuilder(
        animation: widget.slidingAnimation!,
        builder: (context, _) => SlideTransition(
          position: widget.slidingAnimation!,
          child: sheet,
        ),
      );
    }

    return sheet;
  }

  Widget _buildTabContent() {
    final String title = widget.product?.name ?? 'PEUGEOT - LR01';
    final bool isSpecification = _selectedIndex == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bold17.copyWith(color: Colors.white)),
        Gap(8.h),
        if (isSpecification)
          _buildSpecificationContent()
        else
          _buildDescriptionContent(),
      ],
    );
  }

  Widget _buildDescriptionContent() {
    return Text(
      "The LR01 uses the same design as the most iconic bikes from PEUGEOT Cycles' 130-year history and combines it with agile, dynamic performance that's perfectly suited to navigating today's cities. As well as a lugged steel frame and iconic PEUGEOT black-and-white chequer design, this city bike also features a 16-speed Shimano Claris drivetrain.",
      style: AppTextStyles.regular15.copyWith(
        color: Colors.white.withValues(alpha: 0.60),
        height: 1.4,
      ),
    );
  }

  Widget _buildSpecificationContent() {
    final specs = [
      ('Frame', 'Lugged steel heritage road frame'),
      ('Drivetrain', '16-speed Shimano Claris'),
      ('Brakes', 'Promax dual-pivot caliper'),
      ('Wheels', 'Mach1 double-wall alloy rims'),
      ('Weight', '11.2 kg approx.'),
    ];

    return Column(
      children: specs.map((spec) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90.w,
                child: Text(
                  spec.$1,
                  style: AppTextStyles.medium13.copyWith(
                    color: Colors.white.withValues(alpha: 0.50),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  spec.$2,
                  style: AppTextStyles.regular15.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final String price = widget.product?.price ?? '\$ 1,999.99';

    return SizedBox(
      width: double.infinity,
      height: 104.h,
      child: Stack(
        children: [
          Positioned.fill(
            right: -8,
            left: -8,
            bottom: -8,
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xFF262E3D),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2.w,
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      price,
                      style: AppTextStyles.regular24.copyWith(
                        color: AppColors.lightBlue,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gap(12.w),
                  GestureDetector(
                    onTap: widget.onAddToCart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.lightBlue,
                            AppColors.primary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.45),
                            offset: const Offset(0, 1.5),
                            blurRadius: 1.5,
                            inset: true,
                          ),
                          const BoxShadow(
                            color: Color(0xFF2743D8),
                            offset: Offset(0, 3.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        'Add to Cart',
                        style: AppTextStyles.medium15.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
