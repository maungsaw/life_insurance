import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_insurance/design_mockups/mockup_catalog.dart';
import 'package:life_insurance/design_mockups/phone_frame.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Roboto-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    await loader.load();
  });

  for (final branch in mockupBranches) {
    group(branch.title, () {
      for (final entry in branch.screens.entries) {
        testWidgets(entry.key, (tester) async {
          await _capture(
            tester,
            size: kMockupPhoneSize,
            child: entry.value(),
            golden: 'goldens/${branch.id}_${_slug(entry.key)}.png',
          );
        });
      }

      testWidgets('Overview sheet', (tester) async {
        final size = MockupSheet.sizeFor(branch.screens.length);
        await _capture(
          tester,
          size: size,
          child: branch.sheet(),
          golden: 'goldens/${branch.id}_overview_sheet.png',
        );
      });
    });
  }
}

String _slug(String name) => name.toLowerCase().replaceAll(' ', '_');

Future<void> _capture(
  WidgetTester tester, {
  required Size size,
  required Widget child,
  required String golden,
}) async {
  tester.view.physicalSize = Size(size.width * 2, size.height * 2);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: size.width, height: size.height, child: child),
      ),
    ),
  );
  await tester.pump();
  await expectLater(find.byType(MaterialApp), matchesGoldenFile(golden));
}
