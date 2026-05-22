import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/service_model.dart';
import '../../../navigation/app_routes.dart';
import 'package:intl/intl.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final bool isHorizontal;

  const ServiceCard({super.key, required this.service, this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.serviceDetail,
        arguments: service,
      ),
      child: Container(
        width: isHorizontal ? 180 : double.infinity,
        margin: isHorizontal ? const EdgeInsets.only(right: 14) : const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppColors.cardShadow,
        ),
        child: isHorizontal ? _buildHorizontalCard(fmt) : _buildVerticalCard(fmt),
      ),
    );
  }

  Widget _buildHorizontalCard(NumberFormat fmt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withValues(alpha: 0.15), AppColors.primaryCyan.withValues(alpha: 0.15)],
              ),
            ),
            child: Center(child: Text(_categoryEmoji(service.category), style: const TextStyle(fontSize: 44))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    service.rating.toString(),
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  Text(
                    ' (${service.reviewCount})',
                    style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${fmt.format(service.pricePerUnit)}${service.priceUnit}',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalCard(NumberFormat fmt) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue.withValues(alpha: 0.12), AppColors.primaryCyan.withValues(alpha: 0.12)],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Center(child: Text(_categoryEmoji(service.category), style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    Text(' ${service.rating}  •  ${service.reviewCount} ulasan',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${fmt.format(service.pricePerUnit)}${service.priceUnit}',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  String _categoryEmoji(String cat) {
    const map = {
      'Rumah': '🏠', 'Karpet': '🛋️', 'AC': '❄️',
      'Kamar Mandi': '🚿', 'Kantor': '🏢', 'Taman': '🌿', 'Spesial': '🔨',
    };
    return map[cat] ?? '✨';
  }
}
