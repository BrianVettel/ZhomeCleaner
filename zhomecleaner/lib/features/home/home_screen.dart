import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/dummy/services_data.dart';
import '../../data/dummy/cleaners_data.dart';
import '../../data/providers/auth_provider.dart';
import '../../navigation/app_routes.dart';
import 'widgets/promo_banner.dart';
import 'widgets/service_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?.name.split(' ').first ?? 'Pengguna';
    final popularServices = dummyServices.where((s) => s.isPopular).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern off-white background
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, userName),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PromoBanner(),
                  const SizedBox(height: 32),
                  _buildSectionHeader(title: AppStrings.categories),
                  const SizedBox(height: 16),
                  _buildCategories(context),
                  const SizedBox(height: 36),
                  _buildSectionHeader(
                    title: AppStrings.popularServices,
                    onSeeAll: () => Navigator.pushNamed(context, AppRoutes.services),
                  ),
                  const SizedBox(height: 16),
                  _buildPopularServices(popularServices),
                  const SizedBox(height: 36),
                  _buildSectionHeader(title: AppStrings.topCleaners),
                  const SizedBox(height: 16),
                  _buildTopCleaners(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String userName) {
    return SliverAppBar(
      expandedHeight: 150.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), AppColors.primaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.greeting,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userName,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.services),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.search, color: AppColors.textHint, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                AppStrings.searchHint,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textHint,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: serviceCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (ctx, i) {
        final cat = serviceCategories[i];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.services, arguments: cat['id']),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(cat['icon'] as String, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['name'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularServices(List popularServices) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: popularServices.length,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ServiceCard(service: popularServices[i]),
          );
        },
      ),
    );
  }

  Widget _buildTopCleaners() {
    final cleaners = dummyCleaners.where((c) => c.isAvailable).toList();
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: cleaners.length,
        itemBuilder: (ctx, i) {
          final cleaner = cleaners[i];
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                      child: Text(
                        cleaner.name[0],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  cleaner.name.split(' ').first,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${cleaner.rating}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({required String title, VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              AppStrings.seeAll,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
      ],
    );
  }
}
