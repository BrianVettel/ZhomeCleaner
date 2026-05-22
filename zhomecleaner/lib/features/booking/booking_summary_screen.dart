import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/providers/booking_provider.dart';
import '../../navigation/app_routes.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  String _paymentMethod = 'QRIS';
  final _methods = [
    {'id': 'QRIS', 'label': 'QRIS', 'icon': Icons.qr_code_rounded},
    {'id': 'Transfer Bank', 'label': 'Transfer Bank', 'icon': Icons.account_balance_rounded},
    {'id': 'E-Wallet', 'label': 'Dompet Digital', 'icon': Icons.wallet_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BookingProvider>();
    final service = bp.selectedService!;
    final cleaner = bp.selectedCleaner!;
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final dateStr = bp.selectedDate != null
        ? DateFormat('EEEE, d MMMM yyyy', 'id').format(bp.selectedDate!)
        : '-';
    final timeStr = bp.selectedTime?.format(context) ?? '-';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.bookingSummary, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionCard(title: 'Detail Layanan', children: [
                    _InfoRow(label: 'Layanan', value: service.name),
                    _InfoRow(label: 'Durasi', value: '${service.durationMinutes} menit'),
                    _InfoRow(label: 'Harga', value: '${fmt.format(service.pricePerUnit)}${service.priceUnit}'),
                  ]),
                  const SizedBox(height: 14),
                  _SectionCard(title: 'Cleaner', children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                          child: Text(cleaner.name[0], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryBlue)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cleaner.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                              Row(children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                                Text(' ${cleaner.rating}  •  ${cleaner.experienceYears} thn pengalaman',
                                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 14),
                  _SectionCard(title: 'Jadwal & Lokasi', children: [
                    _InfoRow(label: 'Tanggal', value: dateStr),
                    _InfoRow(label: 'Waktu', value: timeStr),
                    _InfoRow(label: 'Alamat', value: bp.address.isEmpty ? 'Jl. Sudirman No. 45' : bp.address),
                    if (bp.notes.isNotEmpty) _InfoRow(label: 'Catatan', value: bp.notes),
                  ]),
                  const SizedBox(height: 14),

                  // Payment method
                  Text(AppStrings.paymentMethod, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  ..._methods.map((m) {
                    final isSelected = _paymentMethod == m['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() => _paymentMethod = m['id'] as String);
                        context.read<BookingProvider>().setPaymentMethod(m['id'] as String);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryBlue : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(m['icon'] as IconData, color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary, size: 22),
                            const SizedBox(width: 12),
                            Text(m['label'] as String,
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary)),
                            const Spacer(),
                            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 14),

                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.totalPayment, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                        Text(fmt.format(bp.estimatedTotal), style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Consumer<BookingProvider>(
              builder: (ctx, bp, _) => CustomButton(
                label: AppStrings.confirmAndPay,
                isLoading: bp.isProcessing,
                onTap: () async {
                  final booking = await bp.confirmBooking();
                  if (booking != null && ctx.mounted) {
                    Navigator.pushReplacementNamed(ctx, AppRoutes.payment, arguments: booking);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Divider(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Text(':  ', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          Expanded(
            child: Text(value, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
