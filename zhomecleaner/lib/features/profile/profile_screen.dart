import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/providers/auth_provider.dart';
import '../../navigation/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final name = user?.name ?? 'Pengguna';
    final email = user?.email ?? '';

    final menus = [
      _MenuItem(icon: Icons.person_outline_rounded, label: AppStrings.editProfile, onTap: () {}),
      _MenuItem(icon: Icons.location_on_outlined, label: AppStrings.myAddress, onTap: () {}),
      _MenuItem(icon: Icons.payment_outlined, label: AppStrings.paymentMethods, onTap: () {}),
      
      // Tambahkan menu "Mode Cleaner" di sini
      _MenuItem(
        icon: Icons.work_outline_rounded, // Ikon tas kerja cocok untuk pekerjaan
        label: 'Daftar / Masuk Sebagai Cleaner',
        onTap: () {

          Navigator.pushNamed(context, AppRoutes.cleanerLogin);
        },
      ),
      
      _MenuItem(icon: Icons.help_outline_rounded, label: AppStrings.help, onTap: () {}),
      _MenuItem(icon: Icons.info_outline_rounded, label: 'Tentang ZhomeCleaner', onTap: () {}),
      _MenuItem(
        icon: Icons.logout_rounded,
        label: AppStrings.logout,
        isDestructive: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Keluar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Text('Apakah Anda yakin ingin keluar?', style: GoogleFonts.poppins(fontSize: 14)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().logout();
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
                  },
                  child: Text('Keluar', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(email, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withValues(alpha: 0.85))),
                      const SizedBox(height: 20),
                      // Stats
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _Stat(value: '3', label: 'Total Pesanan'),
                            Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3)),
                            _Stat(value: '1', label: 'Aktif'),
                            Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.3)),
                            _Stat(value: '1', label: 'Selesai'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: menus.asMap().entries.map((e) {
                    final menu = e.value;
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: menu.isDestructive ? Colors.red.withValues(alpha: 0.08) : AppColors.bgGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(menu.icon, size: 20, color: menu.isDestructive ? Colors.red : AppColors.primaryBlue),
                          ),
                          title: Text(menu.label,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: menu.isDestructive ? Colors.red : AppColors.textPrimary)),
                          trailing: menu.isDestructive
                              ? null
                              : const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                          onTap: menu.onTap,
                        ),
                        if (e.key < menus.length - 1) const Divider(height: 0, indent: 70),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withValues(alpha: 0.85))),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false});
}