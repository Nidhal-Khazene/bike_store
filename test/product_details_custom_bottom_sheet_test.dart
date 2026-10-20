import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/shared/widgets/custom_inner_shadow_container.dart';
import 'package:bike_store/views/widgets/product_details_custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ProductDetailsCustomBottomSheet renders Description and Specification tabs and handles selection',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      int? selectedIndex;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              theme: AppTheme.themeData,
              home: Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: ProductDetailsCustomBottomSheet(
                    onTabChanged: (index) {
                      selectedIndex = index;
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Verify both tabs are rendered
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Specification'), findsOneWidget);
      expect(find.byType(CustomInnerShadowContainer), findsNWidgets(2));

      // Tap on 'Specification'
      await tester.tap(find.text('Specification'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);

      // Tap on 'Description'
      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
    },
  );

  testWidgets(
    'ProductDetailsCustomBottomSheet notifies onExpandedChanged and expands/collapses properly',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool? expandedState;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              theme: AppTheme.themeData,
              home: Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: ProductDetailsCustomBottomSheet(
                    onExpandedChanged: (expanded) {
                      expandedState = expanded;
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Tap Description to expand
      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();

      expect(expandedState, isTrue);

      // Tap Description again to collapse
      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();

      expect(expandedState, isFalse);

      // Tap Specification to expand
      await tester.tap(find.text('Specification'));
      await tester.pumpAndSettle();

      expect(expandedState, isTrue);
    },
  );

  testWidgets(
    'ProductDetailsCustomBottomSheet switches content between Description and Specification',
    (WidgetTester tester) async {
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
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: ProductDetailsCustomBottomSheet(
                    isExpanded: true,
                    initialIndex: 0,
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Description content should be visible initially
      expect(find.textContaining('130-year history'), findsOneWidget);
      expect(find.text('Lugged steel heritage road frame'), findsNothing);

      // Tap Specification tab
      await tester.tap(find.text('Specification'));
      await tester.pumpAndSettle();

      // Specification content should now be visible
      expect(find.text('Lugged steel heritage road frame'), findsOneWidget);
      expect(find.text('16-speed Shimano Claris'), findsOneWidget);
      expect(find.textContaining('130-year history'), findsNothing);
    },
  );

  testWidgets(
    'ProductDetailsCustomBottomSheet renders bottom action bar with price and handles onAddToCart',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool addedToCart = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              theme: AppTheme.themeData,
              home: Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: ProductDetailsCustomBottomSheet(
                    isExpanded: true,
                    onAddToCart: () {
                      addedToCart = true;
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Price and Add to Cart button should be rendered
      expect(find.text('\$ 1,999.99'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);

      // Tap Add to Cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      expect(addedToCart, isTrue);
    },
  );
}
