import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/views/widgets/product_card_widget.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

export 'package:bike_store/views/widgets/product_card_widget.dart';
export 'package:bike_store/views/widgets/product_favorite_button.dart';
export 'package:bike_store/views/widgets/product_item.dart';

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
      final Widget card = ProductCardWidget(
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
