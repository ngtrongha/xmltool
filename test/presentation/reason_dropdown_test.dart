import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/presentation/widgets/reason_dropdown.dart';

void main() {
  testWidgets('ReasonDropdown builds with default initial reason without assertion failure', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReasonDropdown(
            onReasonChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ReasonDropdown), findsOneWidget);
  });

  testWidgets('ReasonDropdown builds with custom non-default initial reason without assertion failure', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReasonDropdown(
            initialReason: 'Lý do tự do tùy biến không có trong danh sách chuẩn',
            onReasonChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ReasonDropdown), findsOneWidget);
    expect(find.text('Lý do tự do tùy biến không có trong danh sách chuẩn'), findsOneWidget);
  });
}
