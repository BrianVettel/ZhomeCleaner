import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Gunakan package import untuk memanggil navigasi dari folder lib
import 'package:zhomecleaner/features/cleaner/navigation/cleaner_bottom_nav.dart'; 

void main() {
  testWidgets('Memastikan CleanerBottomNav dapat merender tanpa error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CleanerBottomNav(),
      ),
    );
    
    // Ekspektasi pengujian Anda di sini
    expect(find.byType(CleanerBottomNav), findsOneWidget);
  });
}