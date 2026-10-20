import 'package:bike_store/views/widgets/my_shopping_cart_view_body.dart';
import 'package:flutter/material.dart';

class MyShoppingCartView extends StatelessWidget {
  const MyShoppingCartView({super.key});
  static const routeName = "MyShoppingCartView";
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MyShoppingCartViewBody(),
        ),
      ),
    );
  }
}
