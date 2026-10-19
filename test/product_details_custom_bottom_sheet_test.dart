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
}
