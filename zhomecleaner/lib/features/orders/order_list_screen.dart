import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/booking_model.dart';
import '../../data/providers/booking_provider.dart';
import '../../navigation/app_routes.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(AppStrings.myOrders,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryBlue,
            tabs: const [
              Tab(text: AppStrings.active),
              Tab(text: AppStrings.completed),
              Tab(text: AppStrings.cancelled),
            ],
          ),
        ),
        body: Consumer<BookingProvider>(
          builder: (ctx, bp, _) => TabBarView(
            children: [
              _OrderTab(orders: bp.activeBookings),
              _OrderTab(orders: bp.completedBookings),
              _OrderTab(orders: bp.cancelledBookings),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTab extends StatelessWidget {
  final List<BookingModel> orders;
  const _OrderTab({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📋', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text('Belum ada pesanan', style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.pagePadding),
      itemCount: orders.length,
      itemBuilder: (ctx, i) => _OrderCard(booking: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final BookingModel booking;
  const _OrderCard({required this.booking});

  Color _statusColor() {
    switch (booking.status) {
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
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final dateStr = DateFormat('d MMM yyyy, HH:mm', 'id').format(booking.scheduledAt);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(booking.id, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(booking.statusLabel,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor())),
                ),
              ],
            ),
            const Divider(height: 16),
            Text(booking.service.name,
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondary),
              Text(' ${booking.cleaner.name}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 16),
              const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
              Text(' $dateStr', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Pembayaran', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                Text(fmt.format(booking.totalPrice),
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
