import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zhomecleaner/data/providers/cleaner_auth_provider.dart';
import 'package:zhomecleaner/data/providers/cleaner_jobs_provider.dart';
import 'package:zhomecleaner/features/cleaner/dashboard/cleaner_dashboard_screen.dart';

void main() {
  testWidgets('CleanerDashboardScreen renders without crashing', (WidgetTester tester) async {
    final authProvider = CleanerAuthProvider();
    final jobsProvider = CleanerJobsProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CleanerAuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<CleanerJobsProvider>.value(value: jobsProvider),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CleanerDashboardScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(CleanerDashboardScreen), findsOneWidget);
    
    // Check if we can find the Halo text
    expect(find.text('Halo,'), findsOneWidget);
  });
}
