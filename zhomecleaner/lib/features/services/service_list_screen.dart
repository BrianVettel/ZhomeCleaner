import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/dummy/services_data.dart';
import '../../data/models/service_model.dart';
import '../../navigation/app_routes.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  String _selectedCategory = 'Semua';
  final _categories = ['Semua', 'Rumah', 'Karpet', 'AC', 'Kamar Mandi', 'Kantor', 'Taman', 'Spesial'];

  List<ServiceModel> get _filtered {
    if (_selectedCategory == 'Semua') return dummyServices;
    return dummyServices.where((s) => s.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Layanan Kami', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : AppColors.bgGrey,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Service list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final service = _filtered[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(ctx, AppRoutes.serviceDetail, arguments: service),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          margin: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primaryBlue.withValues(alpha: 0.12), AppColors.primaryCyan.withValues(alpha: 0.12)],
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                          child: Center(child: Text(_emoji(service.category), style: const TextStyle(fontSize: 36))),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (service.isPopular)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('Populer', style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                                  ),
                                Text(service.name,
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                                  Text(' ${service.rating} (${service.reviewCount})',
                                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                                ]),
                                const SizedBox(height: 4),
                                Text('${fmt.format(service.pricePerUnit)}${service.priceUnit}',
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _emoji(String cat) {
    const map = {'Rumah': '🏠', 'Karpet': '🛋️', 'AC': '❄️', 'Kamar Mandi': '🚿', 'Kantor': '🏢', 'Taman': '🌿', 'Spesial': '🔨'};
    return map[cat] ?? '✨';
  }
}
