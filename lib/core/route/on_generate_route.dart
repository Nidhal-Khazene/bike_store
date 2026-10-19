import 'package:bike_store/views/bike_details_view.dart';
import 'package:bike_store/views/home_view.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    case BikeDetailsView.routeName:
      return MaterialPageRoute(builder: (context) => const BikeDetailsView());

    default:
      return null;
  }
}
