import 'service_model.dart';
import 'cleaner_model.dart';

class BookingModel {
  final String id;
  final ServiceModel service;
  final CleanerModel cleaner;
  final String userId;
  final DateTime scheduledAt;
  final String address;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final String? notes;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.service,
    required this.cleaner,
    required this.userId,
    required this.scheduledAt,
    required this.address,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    this.notes,
    required this.createdAt,
  });

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'ongoing':
        return 'Sedang Berlangsung';
      case 'done':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
