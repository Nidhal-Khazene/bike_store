import 'package:bike_store/views/widgets/bike_details_view_body.dart';
import 'package:flutter/material.dart';

class BikeDetailsView extends StatelessWidget {
  const BikeDetailsView({super.key});
  static const String routeName = "BikeDetailsView";
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BikeDetailsViewBody());
  }
}
