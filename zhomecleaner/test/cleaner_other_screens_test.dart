import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zhomecleaner/data/providers/cleaner_auth_provider.dart';
import 'package:zhomecleaner/data/providers/cleaner_jobs_provider.dart';
import 'package:zhomecleaner/features/cleaner/schedule/cleaner_schedule_screen.dart';
import 'package:zhomecleaner/features/cleaner/wallet/cleaner_wallet_screen.dart';

void main() {
  testWidgets('CleanerScheduleScreen and WalletScreen test', (WidgetTester tester) async {
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
          home: Scaffold(
            body: Column(
              children: [
                Expanded(child: CleanerScheduleScreen()),
                Expanded(child: CleanerWalletScreen()),
              ],
            )
          )
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    expect(find.byType(CleanerScheduleScreen), findsOneWidget);
    expect(find.byType(CleanerWalletScreen), findsOneWidget);
  });
}
