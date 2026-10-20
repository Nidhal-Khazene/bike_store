import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_icon_container.dart';
import 'package:bike_store/views/widgets/product_details_custom_bottom_sheet.dart';
import 'package:bike_store/views/widgets/product_details_view_body.dart';
import 'package:bike_store/views/widgets/product_item.dart';
import 'package:bike_store/views/widgets/sliding_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ProductDetailsViewBody toggles isExpanded and syncs with subwidgets',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const testProduct = ProductItem(
        id: 'test_1',
        name: 'PEUGEOT - LR01',
        category: 'Road Bike',
        price: '\$ 1,999.99',
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
              home: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (ctx) => const Scaffold(
                      body: ProductDetailsViewBody(product: testProduct),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Initially sheet is collapsed (height 110.h)
      AnimatedContainer bottomSheetContainer = tester.widget(
        find.descendant(
          of: find.byType(ProductDetailsCustomBottomSheet),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect(bottomSheetContainer.constraints?.maxHeight, 110.h);

      // SlidingProduct has isExpanded == false
      SlidingProduct slidingProduct = tester.widget(
        find.byType(SlidingProduct),
      );
      expect(slidingProduct.isExpanded, isFalse);

      // Tap on Description tab to expand
      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();

      // Verify sheet is now expanded (height 0.55 * screen height = 446.6)
      bottomSheetContainer = tester.widget(
        find.descendant(
          of: find.byType(ProductDetailsCustomBottomSheet),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect(bottomSheetContainer.constraints?.maxHeight, closeTo(446.6, 0.1));

      // Verify SlidingProduct received isExpanded == true and image remains visible
      slidingProduct = tester.widget(find.byType(SlidingProduct));
      expect(slidingProduct.isExpanded, isTrue);

      final Size expandedImageSize = tester.getSize(
        find.descendant(
          of: find.byType(SlidingProduct),
          matching: find.byType(Image),
        ),
      );
      expect(expandedImageSize.width, greaterThan(0));
      expect(expandedImageSize.height, greaterThan(0));

      // Tapping the top-left button when expanded should collapse the sheet, not pop the screen
      await tester.tap(find.byType(CustomIconContainer));
      await tester.pumpAndSettle();

      // Verify sheet is collapsed again
      bottomSheetContainer = tester.widget(
        find.descendant(
          of: find.byType(ProductDetailsCustomBottomSheet),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect(bottomSheetContainer.constraints?.maxHeight, 110.h);

      slidingProduct = tester.widget(find.byType(SlidingProduct));
      expect(slidingProduct.isExpanded, isFalse);
    },
  );
}
