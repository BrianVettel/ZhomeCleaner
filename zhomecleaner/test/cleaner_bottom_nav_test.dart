import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zhomecleaner/data/providers/cleaner_auth_provider.dart';
import 'package:zhomecleaner/data/providers/cleaner_jobs_provider.dart';
import 'package:zhomecleaner/features/cleaner/navigation/cleaner_bottom_nav.dart';

void main() {
  testWidgets('CleanerBottomNav renders without crashing', (WidgetTester tester) async {
    final auth = CleanerAuthProvider();
    auth.loginCleaner(name: 'Test', email: 'test@test.com');
    await Future.delayed(const Duration(seconds: 1));
    
    final jobs = CleanerJobsProvider();
    jobs.loadDummyJobs();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CleanerAuthProvider>.value(value: auth),
          ChangeNotifierProvider<CleanerJobsProvider>.value(value: jobs),
        ],
        child: const MaterialApp(
          home: CleanerBottomNav(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    expect(find.byType(CleanerBottomNav), findsOneWidget);
  });
}
