import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/pages/profile.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ProfilePage has a title and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilePage()),
    );

    // Verify the profile page contains a title
    expect(find.text('Profile'), findsOneWidget);

    // Verify the profile page contains an Edit button
    expect(find.text('Edit'), findsOneWidget);

    // Verify the profile page contains a Save Changes button
    expect(find.text('Save Changes'), findsNothing); // Initially not present
  });
}
