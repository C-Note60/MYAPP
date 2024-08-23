import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App navigates to ProfilePage', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap on the Profile button to navigate to the ProfilePage
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify the ProfilePage is displayed
    expect(find.text('Profile'), findsOneWidget);
  });
}
