import 'package:bike_store/views/widgets/product_details_view_body.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, this.product});

  static const String routeName = "BikeDetailsView";
  final ProductItem? product;

  @override
  Widget build(BuildContext context) {
    final ProductItem? effectiveProduct =
        product ?? (ModalRoute.of(context)?.settings.arguments as ProductItem?);

    return Scaffold(body: ProductDetailsViewBody(product: effectiveProduct));
  }
}
