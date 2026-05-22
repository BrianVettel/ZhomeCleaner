import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  void login({required String name, required String email, String phone = ''}) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      _user = UserModel(
        id: 'u_001',
        name: name,
        email: email,
        phone: phone.isEmpty ? '0812-3456-7890' : phone,
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        address: 'Jl. Sudirman No. 45, Jakarta Selatan',
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
    });
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateProfile({String? name, String? phone, String? address}) {
    if (_user == null) return;
    _user = _user!.copyWith(
      name: name,
      phone: phone,
      address: address,
    );
    notifyListeners();
  }
}
