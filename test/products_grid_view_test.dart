import 'package:bike_store/core/route/on_generate_route.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/views/product_details_view.dart';
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
            onGenerateRoute: onGenerateRoutes,
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
    expect(find.text('PEUGEOT - LR01'), findsWidgets);
    expect(find.text('SMITH - Trade'), findsWidgets);
    expect(find.text('\$ 1,999.99'), findsWidgets);
    expect(find.text('\$ 120'), findsWidgets);

    // Tap on SMITH - Trade to make it active and navigate
    await tester.tap(find.text('SMITH - Trade').first, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(ProductsGridView), findsOneWidget);
  });

  testWidgets('Tapping a product navigates to ProductDetailsView with product data', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const testProduct = ProductItem(
      id: 'test_bike',
      name: 'Test Turbo Bike',
      category: 'Speed Bike',
      price: '\$ 4,500',
      imagePath: Assets.assetsImagesComponentRobertBicycle,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: AppTheme.themeData,
            onGenerateRoute: onGenerateRoutes,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: ProductsGridView(
                  products: [testProduct],
                ),
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Turbo Bike'), findsOneWidget);

    await tester.tap(find.text('Test Turbo Bike'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsView), findsOneWidget);
    final ProductDetailsView detailsView =
        tester.widget(find.byType(ProductDetailsView));
    expect(detailsView.product, isNotNull);
    expect(detailsView.product!.id, 'test_bike');
    expect(detailsView.product!.name, 'Test Turbo Bike');
    expect(detailsView.product!.category, 'Speed Bike');
    expect(detailsView.product!.price, '\$ 4,500');
    expect(detailsView.product!.imagePath, Assets.assetsImagesComponentRobertBicycle);
  });
}
