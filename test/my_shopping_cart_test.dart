import 'package:bike_store/core/route/on_generate_route.dart';
import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/views/my_shopping_cart_view.dart';
import 'package:bike_store/views/widgets/cart_item_card.dart';
import 'package:bike_store/views/widgets/slide_to_checkout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: AppTheme.themeData,
          onGenerateRoute: onGenerateRoutes,
          home: const MyShoppingCartView(),
        );
      },
    );
  }

  testWidgets(
    'MyShoppingCartView renders all 3 items, initial prices, and subtotal',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Verify App Bar
      expect(find.text('My Shopping Cart'), findsOneWidget);

      // Verify all 3 products are rendered
      expect(find.text('PEUGEOT- LR01'), findsOneWidget);
      expect(find.text('PILOT – CHROMOLY 520'), findsOneWidget);
      expect(find.text('SMITH – Trade'), findsOneWidget);
      expect(find.byType(CartItemCard), findsNWidgets(3));

      // Verify initial prices
      expect(find.text(r'$ 1,999.99'), findsOneWidget);
      expect(find.text(r'$ 3,999.99'), findsOneWidget);
      expect(find.text(r'$ 120'), findsOneWidget);

      // Verify initial Subtotal and Total matching Screen 13 ($6,119.99)
      expect(find.text(r'$6,119.99'), findsNWidgets(2));

      // Verify Free shipping message
      expect(
        find.text('Your bag qualifies for free shipping'),
        findsOneWidget,
      );

      // Verify Checkout button
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.byType(SlideToCheckoutButton), findsOneWidget);
    },
  );

  testWidgets(
    r'Tapping Apply toggles 30% discount and updates total to $4,283.99',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Verify initial state: no discount & delivery fee displayed
      expect(find.text('30%'), findsNothing);
      expect(find.text(r'$0'), findsNothing);

      // Tap "Apply" button
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify discount is applied matching Screen 14:
      // Delivery Fee: $0, Discount: 30%, Total: $4,283.99
      expect(find.text('30%'), findsOneWidget);
      expect(find.text(r'$0'), findsOneWidget);
      expect(find.text(r'$4,283.99'), findsOneWidget);

      // Tap "Apply" again to toggle off
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify reverted to initial state
      expect(find.text('30%'), findsNothing);
      expect(find.text(r'$0'), findsNothing);
      expect(find.text(r'$6,119.99'), findsNWidgets(2));
    },
  );

  testWidgets(
    'SlideToCheckoutButton triggers checkout and shows confirmation dialog',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // First apply coupon so total is $4,283.99 (Screen 14)
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(find.text(r'$4,283.99'), findsOneWidget);

      // Wait for SnackBar duration to expire so it does not block the checkout button
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(SlideToCheckoutButton));
      await tester.pumpAndSettle();

      // Drag or tap slider button to simulate checkout (Screen 15)
      await tester.tap(find.byType(SlideToCheckoutButton));
      await tester.pumpAndSettle();

      // Verify Order Placed dialog is shown
      expect(find.text('Order Placed!'), findsOneWidget);
      expect(find.text('Total Paid: \$4,283.99'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);

      // Tap Back to Home
      await tester.tap(find.text('Back to Home'));
      await tester.pumpAndSettle();

      expect(find.text('Order Placed!'), findsNothing);
    },
  );
}
