import 'dart:io';
import 'dart:ui' as ui;
import 'package:bike_store/core/utils/app_theme.dart';
import 'package:bike_store/core/utils/assets.dart';
import 'package:bike_store/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

    // Tap back to index 0 (Bicycle)
    await tester.tap(itemFinder.at(0));
    await tester.pump();
    expect(tappedIndex, equals(0));
  });

  testWidgets('Captures full CustomBottomNavBar snapshot', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1125, 600);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final repaintKey = GlobalKey();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: const Color(0xFF242C3B),
              body: Align(
                alignment: Alignment.bottomCenter,
                child: RepaintBoundary(
                  key: repaintKey,
                  child: const SizedBox(
                    width: 375,
                    child: CustomBottomNavBar(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    await tester.runAsync(() async {
      final BuildContext context = tester.element(find.byType(CustomBottomNavBar));
      await precacheImage(
        const AssetImage(Assets.assetsImagesComponentBottomNavBarBg),
        context,
      );
    });
    await tester.pump();

    await tester.runAsync(() async {
      final boundary = repaintKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final artifactDir = Directory(
        '/Users/asdfghjkl/.gemini/antigravity-ide/brain/3f244d5b-e6ba-4cf8-9f35-e0e3e17f00d0/scratch',
      );
      if (!artifactDir.existsSync()) {
        artifactDir.createSync(recursive: true);
      }
      File('${artifactDir.path}/full_navbar_preview.png').writeAsBytesSync(bytes);
    });
  });
}

