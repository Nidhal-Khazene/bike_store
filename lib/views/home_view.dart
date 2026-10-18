import 'package:bike_store/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:bike_store/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = "HomeView";
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(),
      body: HomeViewBody(),
    );
  }
}
