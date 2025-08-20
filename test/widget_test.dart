import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/services/firebase_service.dart'; // Import the real class

// Mock class that extends FirebaseService
class MockFirebaseService extends FirebaseService {
  @override
  Future<void> someMethod() async {
    // Optional: fake implementation for test
  }

  // Override any other methods your app calls if needed
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create mock service instance
    final mockService = MockFirebaseService();

    // Build the app and trigger a frame
    await tester.pumpWidget(MyApp(firebaseService: mockService));

    // Verify that our counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
