import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/cleaner_auth_provider.dart';
import '../../../navigation/app_routes.dart';

class CleanerProfileScreen extends StatelessWidget {
  const CleanerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<CleanerAuthProvider>();
    final cleaner = authProvider.cleaner;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // ROOT: SafeArea (tidak pakai Scaffold)
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: [
          // ── PROFILE HEADER ──────────────────────────────
          _buildProfileHeader(cleaner.name, cleaner.rating, cleaner.totalJobsCompleted,
              currency.format(cleaner.totalEarnings)),

          const SizedBox(height: 16),

          // ── MENU ITEMS ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSection('Akun', [
                  _buildMenuItem(CupertinoIcons.person, 'Informasi Pribadi', AppColors.primaryBlue, () {}),
                  _buildMenuItem(CupertinoIcons.doc_checkmark, 'Dokumen Verifikasi', AppColors.primaryCyan, () {}),
                  _buildMenuItem(CupertinoIcons.money_dollar_circle, 'Rekening Bank', AppColors.statusDone, () {}),
                ]),
                const SizedBox(height: 16),
                _buildSection('Preferensi', [
                  _buildMenuItem(CupertinoIcons.bell, 'Pengaturan Notifikasi', AppColors.accentOrange, () {}),
                  _buildMenuItem(CupertinoIcons.map, 'Area Layanan', AppColors.statusConfirmed, () {}),
                ]),
                const SizedBox(height: 16),
                _buildSection('Lainnya', [
                  _buildMenuItem(CupertinoIcons.question_circle, 'Pusat Bantuan', Colors.purple, () {}),
                  _buildMenuItem(CupertinoIcons.shield, 'Kebijakan Privasi', Colors.teal, () {}),
                ]),
                const SizedBox(height: 24),

                // ── LOGOUT BUTTON ─────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authProvider.logoutCleaner();
                      Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.cleanerLogin, (route) => false);
                    },
                    icon: const Icon(CupertinoIcons.square_arrow_left, size: 18),
                    label: const Text('Keluar Akun',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String name, double rating, int totalJobs, String totalEarnings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(CupertinoIcons.person_fill, size: 46, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Mitra Terverifikasi ✓',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _headerStat(rating.toStringAsFixed(1), 'Rating', CupertinoIcons.star_fill, Colors.amber),
              _divider(),
              _headerStat('$totalJobs', 'Pekerjaan', CupertinoIcons.checkmark_seal_fill, Colors.greenAccent),
              _divider(),
              _headerStat(totalEarnings, 'Total Pendapatan', CupertinoIcons.money_dollar_circle_fill, Colors.white70, small: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: Colors.white30);

  Widget _headerStat(String val, String label, IconData icon, Color color, {bool small = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(val,
            style: TextStyle(fontSize: small ? 12 : 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title.toUpperCase(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
            const Icon(CupertinoIcons.chevron_right, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
