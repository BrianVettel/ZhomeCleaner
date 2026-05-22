import 'package:flutter/material.dart';
import '../models/cleaner_account_model.dart';

class CleanerAuthProvider extends ChangeNotifier {
  // ✅ Data cleaner sudah tersedia sejak awal — tidak null saat halaman dirender.
  // Dalam produksi, ganti dengan hasil dari API / SharedPreferences.
  CleanerAccountModel _cleaner = CleanerAccountModel(
    id: 'c_001',
    name: 'Cleaner Demo',
    email: 'cleaner@zhome.com',
    phone: '0821-0000-1111',
    isAvailable: true,
    rating: 4.8,
    totalJobsCompleted: 128,
    totalEarnings: 18500000,
    walletBalance: 2350000,
    bankAccountNumber: '1234567890',
    eWalletNumber: '082100001111',
    workingDays: [1, 2, 3, 4, 5],
    registeredAt: DateTime(2024, 1, 10),
    area: 'Jakarta Selatan',
  );

  bool _isLoggedIn = false;
  bool _isLoading = false;

  // Non-nullable getter — TIDAK akan pernah null lagi
  CleanerAccountModel get cleaner => _cleaner;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> loginCleaner({
    required String name,
    required String email,
    String phone = '',
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi API call
    await Future.delayed(const Duration(milliseconds: 600));

    _cleaner = CleanerAccountModel(
      id: 'c_001',
      name: name.isNotEmpty ? name : 'Mitra Cleaner',
      email: email,
      phone: phone.isEmpty ? '0821-0000-1111' : phone,
      isAvailable: true,
      rating: 4.8,
      totalJobsCompleted: 128,
      totalEarnings: 18500000,
      walletBalance: 2350000,
      bankAccountNumber: '1234567890',
      eWalletNumber: '082100001111',
      workingDays: [1, 2, 3, 4, 5],
      registeredAt: DateTime(2024, 1, 10),
      area: 'Jakarta Selatan',
    );
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  void registerCleaner({
    required String name,
    required String email,
    required String phone,
    String area = 'Jakarta',
  }) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      _cleaner = CleanerAccountModel(
        id: 'c_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        isAvailable: true,
        rating: 5.0,
        totalJobsCompleted: 0,
        totalEarnings: 0,
        walletBalance: 0,
        workingDays: [1, 2, 3, 4, 5],
        registeredAt: DateTime.now(),
        area: area,
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleAvailability() {
    _cleaner = _cleaner.copyWith(isAvailable: !_cleaner.isAvailable);
    notifyListeners();
  }

  void logoutCleaner() {
    // Reset ke default cleaner saat logout, tidak null
    _cleaner = CleanerAccountModel(
      id: '',
      name: 'Cleaner Demo',
      email: '',
      phone: '',
      isAvailable: false,
      rating: 0,
      totalJobsCompleted: 0,
      totalEarnings: 0,
      walletBalance: 0,
      workingDays: [],
      registeredAt: DateTime.now(),
      area: '',
    );
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateWorkingDays(List<int> days) {
    _cleaner = _cleaner.copyWith(workingDays: days);
    notifyListeners();
  }
}
