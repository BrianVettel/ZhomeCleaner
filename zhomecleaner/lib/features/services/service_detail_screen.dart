import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/dummy/services_data.dart';
import '../../data/models/service_model.dart';
import '../../data/providers/booking_provider.dart';
import '../../navigation/app_routes.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  String _emoji(String cat) {
    const map = {'Rumah': '🏠', 'Karpet': '🛋️', 'AC': '❄️', 'Kamar Mandi': '🚿', 'Kantor': '🏢', 'Taman': '🌿', 'Spesial': '🔨'};
    return map[cat] ?? '✨';
  }

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)!.settings.arguments as ServiceModel;
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero image area
              SliverToBoxAdapter(
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryBlue.withValues(alpha: 0.15), AppColors.primaryCyan.withValues(alpha: 0.15)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Text(_emoji(service.category), style: const TextStyle(fontSize: 100))),
                      Positioned(
                        top: 48,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.all(AppDimensions.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(service.name,
                                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          ),
                          if (service.isPopular)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
                              child: Text('Populer', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          Text(' ${service.rating}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(' (${service.reviewCount} ulasan)', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                          const Spacer(),
                          const Icon(Icons.schedule_rounded, size: 16, color: AppColors.textSecondary),
                          Text(' ${service.durationMinutes} menit', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${fmt.format(service.pricePerUnit)}${service.priceUnit}',
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      const Divider(height: 28),
                      Text('Deskripsi', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      Text(service.description, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
                      const SizedBox(height: 20),
                      Text('Yang Termasuk', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      ...service.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 22, height: 22,
                              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                              child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(f, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
                          ],
                        ),
                      )),
                      const Divider(height: 28),
                      Text('Ulasan Pengguna', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      ...serviceReviews.map((r) => _ReviewCard(review: r)),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom book button
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              color: AppColors.bgCard,
              child: CustomButton(
                label: AppStrings.bookNow,
                onTap: () {
                  context.read<BookingProvider>().selectService(service);
                  Navigator.pushNamed(context, AppRoutes.booking);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                child: Text(
                  (review['name'] as String)[0],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(review['date'] as String, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < (review['rating'] as double).floor() ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber, size: 14,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review['comment'] as String, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}
