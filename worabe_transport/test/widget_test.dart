import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/app.dart';

void main() {
  testWidgets('Welcome screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: WorabeTransportApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Worabe Transport'), findsWidgets);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
