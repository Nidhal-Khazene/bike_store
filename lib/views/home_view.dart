import 'package:bike_store/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = "HomeView";
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomeViewBody());
  }
}
