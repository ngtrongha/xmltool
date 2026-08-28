import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/app.dart';
import 'package:xmltool/core/di/injection.dart';

void main() {
  testWidgets('App smoke test loads ImportPage in Desktop Shell', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await configureDependencies();

    await tester.pumpWidget(const BHYTApp());
    await tester.pumpAndSettle();

    expect(find.text('BHYT XML Tool'), findsOneWidget);
    expect(find.text('BẮT ĐẦU ĐỐI SOÁT'), findsOneWidget);
  });
}
