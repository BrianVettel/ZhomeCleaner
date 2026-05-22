import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zhomecleaner/app/app.dart';
import 'package:zhomecleaner/data/providers/auth_provider.dart';
import 'package:zhomecleaner/data/providers/booking_provider.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BookingProvider()),
        ],
        child: const ZhomeCleanerApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
