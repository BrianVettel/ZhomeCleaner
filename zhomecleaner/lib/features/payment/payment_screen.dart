import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/booking_model.dart';
import '../../navigation/app_routes.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as BookingModel;
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110, height: 110,
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
              ),
              const SizedBox(height: 24),
              Text(AppStrings.paymentSuccess,
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(AppStrings.paymentSuccessDesc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    _Row(label: AppStrings.orderNumber, value: booking.id, isHighlight: true),
                    const Divider(height: 20),
                    _Row(label: 'Layanan', value: booking.service.name),
                    _Row(label: 'Cleaner', value: booking.cleaner.name),
                    _Row(label: 'Metode Bayar', value: booking.paymentMethod),
                    _Row(
                        label: AppStrings.totalPayment,
                        value: fmt.format(booking.totalPrice),
                        isHighlight: true),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: AppStrings.backToHome,
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Lihat Pesanan',
                isOutlined: true,
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.orders,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _Row({required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isHighlight ? 14 : 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? AppColors.primaryBlue : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
