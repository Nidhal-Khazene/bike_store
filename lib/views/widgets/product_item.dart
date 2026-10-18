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
