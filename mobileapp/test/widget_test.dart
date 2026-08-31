import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/main.dart';

void main() {
  testWidgets('App launches with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NawasulApp(),
      ),
    );

    await tester.pump();

    expect(find.text('NAWASUL'), findsOneWidget);
  });
}
