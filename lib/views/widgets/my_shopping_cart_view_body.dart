import 'package:bike_store/views/widgets/my_shopping_cart_app_bar.dart';
import 'package:flutter/material.dart';

class MyShoppingCartViewBody extends StatelessWidget {
  const MyShoppingCartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [MyShoppingCartAppBar()]);
  }
}
