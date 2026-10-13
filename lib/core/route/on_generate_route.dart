import 'package:bike_store/views/home_view.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());

    default:
      return null;
  }
}
