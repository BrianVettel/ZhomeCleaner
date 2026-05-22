import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/booking_model.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  Color _statusColor(String s) {
    switch (s) {
      case 'pending': return AppColors.statusPending;
      case 'confirmed': return AppColors.statusConfirmed;
      case 'ongoing': return AppColors.statusOngoing;
      case 'done': return AppColors.statusDone;
      case 'cancelled': return AppColors.statusCancelled;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as BookingModel;
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
        title: Text('Detail Pesanan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Column(
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      // Memanggil _statusColor agar warna label sesuai statusnya
                      color: _statusColor(booking.status), 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(booking.statusLabel,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(height: 12),
                  Text(booking.id, style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(fmt.format(booking.totalPrice),
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailCard(title: 'Layanan', rows: [
              _Row('Nama', booking.service.name),
              _Row('Kategori', booking.service.category),
              _Row('Durasi', '${booking.service.durationMinutes} menit'),
            ]),
            const SizedBox(height: 12),
            _DetailCard(title: 'Cleaner', rows: [
              _Row('Nama', booking.cleaner.name),
              _Row('Rating', '⭐ ${booking.cleaner.rating}'),
              _Row('Pengalaman', '${booking.cleaner.experienceYears} tahun'),
            ]),
            const SizedBox(height: 12),
            _DetailCard(title: 'Jadwal & Lokasi', rows: [
              _Row('Tanggal', DateFormat('d MMMM yyyy', 'id').format(booking.scheduledAt)),
              _Row('Waktu', DateFormat('HH:mm').format(booking.scheduledAt)),
              _Row('Alamat', booking.address),
              if (booking.notes != null) _Row('Catatan', booking.notes!),
            ]),
            const SizedBox(height: 12),
            _DetailCard(title: 'Pembayaran', rows: [
              _Row('Metode', booking.paymentMethod),
              _Row('Total', fmt.format(booking.totalPrice)),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<_Row> rows;
  const _DetailCard({required this.title, required this.rows});

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
          ...rows,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
          Text(':  ', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}