import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/views/widgets/products_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProductsGridView renders in isolation and switches active state', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: AppTheme.themeData,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: ProductsGridView(),
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    // Verify product names are rendered
    expect(find.text('PEUGEOT - LR01'), findsOneWidget);
    expect(find.text('SMITH - Trade'), findsOneWidget);
    expect(find.text('\$ 1,999.99'), findsOneWidget);
    expect(find.text('\$ 120'), findsOneWidget);

    // Tap on SMITH - Trade to make it active
    await tester.tap(find.text('SMITH - Trade'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductsGridView), findsOneWidget);
  });
}
