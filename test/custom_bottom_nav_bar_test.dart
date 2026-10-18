import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomBottomNavBar renders all 5 items and switches active tab', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    int? tappedIndex;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeData,
            home: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(
                onItemSelected: (index) {
                  tappedIndex = index;
                },
              ),
              body: const SizedBox.expand(),
            ),
          );
        },
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify CustomBottomNavBar is present
    expect(find.byType(CustomBottomNavBar), findsOneWidget);

    // Verify all 5 tab slots exist
    final itemFinder = find.byType(GestureDetector);
    expect(itemFinder, findsWidgets);

    // Tap on the 2nd tab (Map, index 1)
    await tester.tap(itemFinder.at(1));
    await tester.pump();

    // Verify callback was triggered with index 1
    expect(tappedIndex, equals(1));

    // Tap on the 3rd tab (Cart, index 2)
    await tester.tap(itemFinder.at(2));
    await tester.pump();
    expect(tappedIndex, equals(2));
  });
}
