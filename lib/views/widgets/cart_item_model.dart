import 'package:bike_store/core/utils/assets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// S — Single Responsibility: pure data model representing a shopping cart item.
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a single item in the shopping cart.
class CartItemModel {
  final String id;
  final String name;
  final double price;
  final String priceDisplay;
  final String imagePath;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.priceDisplay,
    required this.imagePath,
    this.quantity = 1,
  });

  /// Total price for this cart item based on its quantity.
  double get totalPrice => price * quantity;

  /// Creates a copy of this [CartItemModel] with updated fields.
  CartItemModel copyWith({
    String? id,
    String? name,
    double? price,
    String? priceDisplay,
    String? imagePath,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      priceDisplay: priceDisplay ?? this.priceDisplay,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Initial list of cart items matching the design mockups:
  /// - PEUGEOT- LR01 ($ 1,999.99)
  /// - PILOT – CHROMOLY 520 ($ 3,999.99)
  /// - SMITH – Trade ($ 120)
  /// Sum = $6,119.99 (matching Screen 13)
  static List<CartItemModel> get initialCartItems => [
        const CartItemModel(
          id: '1',
          name: 'PEUGEOT- LR01',
          price: 1999.99,
          priceDisplay: r'$ 1,999.99',
          imagePath: Assets.assetsImagesComponentMikkelBechBicycle,
          quantity: 1,
        ),
        const CartItemModel(
          id: '2',
          name: 'PILOT – CHROMOLY 520',
          price: 3999.99,
          priceDisplay: r'$ 3,999.99',
          imagePath: Assets.assetsImagesComponentRobertBicycle,
          quantity: 1,
        ),
        const CartItemModel(
          id: '3',
          name: 'SMITH – Trade',
          price: 120.01,
          priceDisplay: r'$ 120',
          imagePath: Assets.assetsImagesComponentBicycleHat,
          quantity: 1,
        ),
      ];
}
