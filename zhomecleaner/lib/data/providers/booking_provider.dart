import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/cleaner_model.dart';
import '../models/booking_model.dart';
import '../dummy/services_data.dart';
import '../dummy/cleaners_data.dart';

class BookingProvider extends ChangeNotifier {
  ServiceModel? _selectedService;
  CleanerModel? _selectedCleaner;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _address = '';
  String _notes = '';
  String _paymentMethod = 'QRIS';
  bool _isProcessing = false;

  final List<BookingModel> _bookings = [];

  ServiceModel? get selectedService => _selectedService;
  CleanerModel? get selectedCleaner => _selectedCleaner;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get address => _address;
  String get notes => _notes;
  String get paymentMethod => _paymentMethod;
  bool get isProcessing => _isProcessing;
  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  List<BookingModel> get activeBookings =>
      _bookings.where((b) => b.status == 'pending' || b.status == 'confirmed' || b.status == 'ongoing').toList();
  List<BookingModel> get completedBookings =>
      _bookings.where((b) => b.status == 'done').toList();
  List<BookingModel> get cancelledBookings =>
      _bookings.where((b) => b.status == 'cancelled').toList();

  void selectService(ServiceModel service) {
    _selectedService = service;
    _selectedCleaner = null;
    notifyListeners();
  }

  void selectCleaner(CleanerModel cleaner) {
    _selectedCleaner = cleaner;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  double get estimatedTotal {
    if (_selectedService == null) return 0;
    return _selectedService!.pricePerUnit * 2;
  }

  Future<BookingModel?> confirmBooking() async {
    if (_selectedService == null || _selectedCleaner == null || _selectedDate == null) {
      return null;
    }
    _isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final booking = BookingModel(
      id: 'BK${DateTime.now().millisecondsSinceEpoch}',
      service: _selectedService!,
      cleaner: _selectedCleaner!,
      userId: 'u_001',
      scheduledAt: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime?.hour ?? 9,
        _selectedTime?.minute ?? 0,
      ),
      address: _address.isEmpty ? 'Jl. Sudirman No. 45, Jakarta Selatan' : _address,
      totalPrice: estimatedTotal,
      status: 'confirmed',
      paymentMethod: _paymentMethod,
      notes: _notes.isEmpty ? null : _notes,
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, booking);
    _isProcessing = false;
    _resetBookingState();
    notifyListeners();
    return booking;
  }

  void _resetBookingState() {
    _selectedService = null;
    _selectedCleaner = null;
    _selectedDate = null;
    _selectedTime = null;
    _address = '';
    _notes = '';
    _paymentMethod = 'QRIS';
  }

  void loadDummyBookings() {
    if (_bookings.isNotEmpty) return;
    _bookings.addAll([
      BookingModel(
        id: 'BK001',
        service: dummyServices[0],
        cleaner: dummyCleaners[0],
        userId: 'u_001',
        scheduledAt: DateTime.now().add(const Duration(days: 2, hours: 9)),
        address: 'Jl. Sudirman No. 45, Jakarta Selatan',
        totalPrice: 300000,
        status: 'confirmed',
        paymentMethod: 'QRIS',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      BookingModel(
        id: 'BK002',
        service: dummyServices[3],
        cleaner: dummyCleaners[1],
        userId: 'u_001',
        scheduledAt: DateTime.now().subtract(const Duration(days: 5)),
        address: 'Jl. Sudirman No. 45, Jakarta Selatan',
        totalPrice: 350000,
        status: 'done',
        paymentMethod: 'Transfer Bank',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      BookingModel(
        id: 'BK003',
        service: dummyServices[2],
        cleaner: dummyCleaners[2],
        userId: 'u_001',
        scheduledAt: DateTime.now().subtract(const Duration(days: 12)),
        address: 'Jl. Gatot Subroto No. 12, Jakarta Selatan',
        totalPrice: 400000,
        status: 'cancelled',
        paymentMethod: 'QRIS',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ]);
    notifyListeners();
  }
}
