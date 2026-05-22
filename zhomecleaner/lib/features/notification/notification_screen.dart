import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotifData(
        icon: Icons.check_circle_rounded,
        color: AppColors.statusDone,
        title: 'Pesanan Dikonfirmasi',
        body: 'Pesanan BK001 telah dikonfirmasi. Cleaner Siti Rahayu akan datang Rabu, 22 Mei 2026.',
        time: '2 jam lalu',
      ),
      _NotifData(
        icon: Icons.local_offer_rounded,
        color: AppColors.accentOrange,
        title: 'Promo Spesial Untukmu!',
        body: 'Dapatkan diskon 30% untuk layanan Kebersihan Rumah. Berlaku sampai 31 Mei 2026.',
        time: '5 jam lalu',
      ),
      _NotifData(
        icon: Icons.star_rounded,
        color: Colors.amber,
        title: 'Beri Rating Layanan',
        body: 'Bagaimana layanan Cuci Karpet pada 8 Mei lalu? Berikan ulasan Anda.',
        time: '2 hari lalu',
      ),
      _NotifData(
        icon: Icons.campaign_rounded,
        color: AppColors.primaryBlue,
        title: 'Selamat Bergabung!',
        body: 'Selamat datang di ZhomeCleaner! Nikmati layanan pertama Anda dengan gratis ongkos kedatangan.',
        time: '7 hari lalu',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(AppStrings.notifications,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔔', style: TextStyle(fontSize: 52)),
                  const SizedBox(height: 16),
                  Text(AppStrings.noNotifications,
                      style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final n = notifications[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: n.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(n.icon, color: n.color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(n.title,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Text(n.time,
                                    style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(n.body,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: AppColors.textSecondary, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _NotifData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;

  const _NotifData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });
}
