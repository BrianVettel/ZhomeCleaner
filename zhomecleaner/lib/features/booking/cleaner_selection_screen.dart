import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/dummy/cleaners_data.dart';
import '../../data/models/cleaner_model.dart';
import '../../data/providers/booking_provider.dart';
import '../../navigation/app_routes.dart';

class CleanerSelectionScreen extends StatefulWidget {
  const CleanerSelectionScreen({super.key});

  @override
  State<CleanerSelectionScreen> createState() => _CleanerSelectionScreenState();
}

class _CleanerSelectionScreenState extends State<CleanerSelectionScreen> {
  CleanerModel? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.selectCleaner, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              itemCount: dummyCleaners.length,
              itemBuilder: (ctx, i) {
                final cleaner = dummyCleaners[i];
                final isSelected = _selected?.id == cleaner.id;
                return GestureDetector(
                  onTap: cleaner.isAvailable ? () => setState(() => _selected = cleaner) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryBlue : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? AppColors.buttonShadow : AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                          child: Text(
                            cleaner.name[0],
                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(cleaner.name,
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: cleaner.isAvailable ? AppColors.accentGreen.withValues(alpha: 0.12) : Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      cleaner.isAvailable ? AppStrings.available : AppStrings.notAvailable,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: cleaner.isAvailable ? AppColors.accentGreen : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                Text(' ${cleaner.rating}  •  ${cleaner.totalJobs} pekerjaan  •  ${cleaner.experienceYears} thn',
                                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                              ]),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                children: cleaner.specializations.map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgGrey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(s, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
                                )).toList(),
                              ),
                              const SizedBox(height: 8),
                              Text(cleaner.bio,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, height: 1.4)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue, size: 24),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: CustomButton(
              label: AppStrings.next,
              onTap: _selected == null
                  ? null
                  : () {
                      context.read<BookingProvider>().selectCleaner(_selected!);
                      Navigator.pushNamed(context, AppRoutes.bookingSummary);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
