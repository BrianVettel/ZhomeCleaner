import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/providers/cleaner_auth_provider.dart';
import '../../../data/providers/cleaner_jobs_provider.dart';
import '../../../navigation/app_routes.dart';

class CleanerLoginScreen extends StatefulWidget {
  const CleanerLoginScreen({super.key});

  @override
  State<CleanerLoginScreen> createState() => _CleanerLoginScreenState();
}

class _CleanerLoginScreenState extends State<CleanerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<CleanerAuthProvider>();
    await auth.loginCleaner(
      name: _emailCtrl.text.split('@').first,
      email: _emailCtrl.text,
    );
    if (!mounted) return;
    context.read<CleanerJobsProvider>().loadDummyJobs();
    Navigator.pushReplacementNamed(context, AppRoutes.cleanerHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient hijau-teal
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B8B5B), Color(0xFF00BFA5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🏆', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Portal Mitra Cleaner',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Kelola pekerjaan Anda dengan mudah',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Selamat Datang, Mitra! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Masuk untuk mulai menerima pesanan',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Email',
                      hint: 'email@mitra.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email wajib diisi';
                        if (!v.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandi',
                      controller: _passCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textHint),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer<CleanerAuthProvider>(
                      builder: (ctx, auth, _) => _CleanerButton(
                        label: 'Masuk sebagai Cleaner',
                        isLoading: auth.isLoading,
                        onTap: _login,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum terdaftar? ',
                          style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.cleanerRegister),
                          child: Text(
                            'Daftar Sekarang',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1B8B5B),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Kembali ke Aplikasi Customer',
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
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

class _CleanerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _CleanerButton({required this.label, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B8B5B), Color(0xFF00BFA5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B8B5B).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
        ),
      ),
    );
  }
}
