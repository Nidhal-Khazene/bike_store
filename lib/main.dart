import 'package:bike_store/core/route/on_generate_route.dart';
import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const BikeStore());
}

class BikeStore extends StatelessWidget {
  const BikeStore({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          onGenerateRoute: onGenerateRoutes,
          initialRoute: HomeView.routeName,
        );
      },
    );
  }
}
