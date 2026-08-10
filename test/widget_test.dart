import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FutoshikiApp()),
    );
    expect(find.text('Futoshiki for Adults'), findsWidgets);
  });
}
