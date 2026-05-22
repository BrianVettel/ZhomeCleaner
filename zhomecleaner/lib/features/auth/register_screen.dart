import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/booking_provider.dart';
import '../../navigation/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthProvider>().login(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
    );
    context.read<BookingProvider>().loadDummyBookings();
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Buat Akun Baru',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Bergabung dengan ZhomeCleaner',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: AppStrings.fullName,
                      hint: 'Nama lengkap Anda',
                      controller: _nameCtrl,
                      prefixIcon: const Icon(Icons.person_outline, size: 20, color: AppColors.textHint),
                      validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: AppStrings.email,
                      hint: 'nama@email.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email wajib diisi';
                        if (!v.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: AppStrings.phoneNumber,
                      hint: '08xx-xxxx-xxxx',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.textHint),
                      validator: (v) => (v == null || v.isEmpty) ? 'Nomor HP wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: AppStrings.password,
                      hint: 'Minimal 6 karakter',
                      controller: _passCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: AppStrings.confirmPassword,
                      hint: 'Ulangi kata sandi',
                      controller: _confirmPassCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Konfirmasi wajib diisi';
                        if (v != _passCtrl.text) return 'Kata sandi tidak sama';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (ctx, auth, _) => CustomButton(
                        label: AppStrings.register,
                        isLoading: auth.isLoading,
                        onTap: _register,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            AppStrings.login,
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
