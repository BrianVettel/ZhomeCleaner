import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../dashboard/cleaner_dashboard_screen.dart';
import '../orders/cleaner_orders_list_screen.dart';
import '../schedule/cleaner_schedule_screen.dart';
import '../wallet/cleaner_wallet_screen.dart';
import '../profile/cleaner_profile_screen.dart';

class CleanerBottomNav extends StatefulWidget {
  const CleanerBottomNav({super.key});

  @override
  State<CleanerBottomNav> createState() => _CleanerBottomNavState();
}

class _CleanerBottomNavState extends State<CleanerBottomNav> {
  int _currentIndex = 0;

  // Daftar screen dibuat sebagai list konstan.
  // Setiap screen adalah StatefulWidget biasa tanpa Scaffold sendiri.
  static const _screens = [
    CleanerDashboardScreen(),
    CleanerOrdersListScreen(),
    CleanerScheduleScreen(),
    CleanerWalletScreen(),
    CleanerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold ini SATU-SATUNYA Scaffold untuk seluruh cleaner portal.
    // Semua screen child TIDAK boleh memiliki Scaffold sendiri.
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      // body langsung menampilkan screen yang aktif.
      // Ini cara paling sederhana dan paling aman untuk menghindari
      // RenderBox constraint errors.
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              activeIcon: Icon(CupertinoIcons.house_fill),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_text),
              activeIcon: Icon(CupertinoIcons.doc_text_fill),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              activeIcon: Icon(CupertinoIcons.calendar_today),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar_circle),
              activeIcon: Icon(CupertinoIcons.money_dollar_circle_fill),
              label: 'Dompet',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              activeIcon: Icon(CupertinoIcons.person_fill),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}