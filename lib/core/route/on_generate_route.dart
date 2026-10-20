import 'package:bike_store/views/my_shopping_cart_view.dart';
import 'package:bike_store/views/product_details_view.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:bike_store/views/home_view.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeView(),
        settings: settings,
      );
    case ProductDetailsView.routeName:
      final ProductItem? product = settings.arguments as ProductItem?;
      return MaterialPageRoute(
        builder: (context) => ProductDetailsView(product: product),
        settings: settings,
      );
    case MyShoppingCartView.routeName:
      return MaterialPageRoute(
        builder: (context) => const MyShoppingCartView(),
      );
    default:
      return null;
  }
}
