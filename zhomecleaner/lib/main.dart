import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/booking_provider.dart';
import 'data/providers/cleaner_auth_provider.dart';
import 'data/providers/cleaner_jobs_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => CleanerAuthProvider()),
        ChangeNotifierProvider(create: (_) => CleanerJobsProvider()),
      ],
      child: const ZhomeCleanerApp(),
    ),
  );
}