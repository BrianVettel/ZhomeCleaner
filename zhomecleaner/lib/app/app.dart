import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/booking/booking_summary_screen.dart';
import '../features/booking/cleaner_selection_screen.dart';
import '../features/notification/notification_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/order_list_screen.dart';
import '../features/payment/payment_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/services/service_detail_screen.dart';
import '../features/services/service_list_screen.dart';
import '../features/splash/splash_screen.dart';
import '../navigation/app_routes.dart';
import '../navigation/bottom_nav.dart';

// Import untuk halaman Cleaner
import '../features/cleaner/auth/cleaner_login_screen.dart';
import '../features/cleaner/auth/cleaner_register_screen.dart';
import '../features/cleaner/navigation/cleaner_bottom_nav.dart';
import '../features/cleaner/orders/cleaner_order_detail_screen.dart';
import '../features/cleaner/job_execution/job_execution_screen.dart';

class ZhomeCleanerApp extends StatefulWidget {
  const ZhomeCleanerApp({super.key});

  @override
  State<ZhomeCleanerApp> createState() => _ZhomeCleanerAppState();
}

class _ZhomeCleanerAppState extends State<ZhomeCleanerApp> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZhomeCleaner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // ✅ PERBAIKAN: Mengembalikan rute awal ke Splash Screen
      initialRoute: AppRoutes.splash, 
      
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const BottomNav(),
        AppRoutes.services: (_) => const ServiceListScreen(),
        AppRoutes.serviceDetail: (_) => const ServiceDetailScreen(),
        AppRoutes.booking: (_) => const BookingScreen(),
        AppRoutes.cleanerSelect: (_) => const CleanerSelectionScreen(),
        AppRoutes.bookingSummary: (_) => const BookingSummaryScreen(),
        AppRoutes.payment: (_) => const PaymentScreen(),
        AppRoutes.orders: (_) => const OrderListScreen(),
        AppRoutes.orderDetail: (_) => const OrderDetailScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.notifications: (_) => const NotificationScreen(),

        // 👇 Rute khusus Fitur Mitra Cleaner 👇
        AppRoutes.cleanerLogin: (_) => const CleanerLoginScreen(),
        AppRoutes.cleanerRegister: (_) => const CleanerRegisterScreen(),
        AppRoutes.cleanerHome: (_) => const CleanerBottomNav(),
        AppRoutes.cleanerOrderDetail: (ctx) => CleanerOrderDetailScreen(
              jobId: ModalRoute.of(ctx)!.settings.arguments as String,
            ),
        AppRoutes.cleanerJobExecution: (ctx) => JobExecutionScreen(
              jobId: ModalRoute.of(ctx)!.settings.arguments as String,
            ),
      },
    );
  }
}