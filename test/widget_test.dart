import 'package:flutter_test/flutter_test.dart';
import 'package:xmltool/app.dart';
import 'package:xmltool/core/di/injection.dart';

void main() {
  testWidgets('App smoke test loads ImportPage', (WidgetTester tester) async {
    await configureDependencies();

    await tester.pumpWidget(const BHYTApp());
    await tester.pumpAndSettle();

    expect(find.text('BHYT XML Adjustment Tool'), findsOneWidget);
    expect(find.text('BẮT ĐẦU ĐỐI SOÁT'), findsOneWidget);
  });
}
