import 'package:bike_store/shared/widgets/custom_inner_shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsCustomBottomSheet extends StatefulWidget {
  const ProductDetailsCustomBottomSheet({
    super.key,
    this.initialIndex,
    this.onTabChanged,
  });

  final int? initialIndex;
  final ValueChanged<int>? onTabChanged;

  @override
  State<ProductDetailsCustomBottomSheet> createState() =>
      _ProductDetailsCustomBottomSheetState();
}

class _ProductDetailsCustomBottomSheetState
    extends State<ProductDetailsCustomBottomSheet> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _handleTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110.h,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 44.w),
        child: Row(
          children: [
            Expanded(
              child: CustomInnerShadowContainer(
                title: "Description",
                isSelected: _selectedIndex == 0,
                onTap: () => _handleTap(0),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: CustomInnerShadowContainer(
                title: "Specification",
                isSelected: _selectedIndex == 1,
                onTap: () => _handleTap(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
